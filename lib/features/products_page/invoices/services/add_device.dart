import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Represents a Bluetooth device discovered during scanning.
class BluetoothDevice {
  final String? name;
  final String? address;

  BluetoothDevice({this.name, this.address});

  factory BluetoothDevice.fromJson(Map<String, dynamic> json) {
    return BluetoothDevice(name: json['name'], address: json['address']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address};
  }
}

/// Connection state of Bluetooth
enum ConnectState { connected, disconnected, connecting }

/// Bluetooth power state
enum BlueState { blueOn, blueOff }

/// Helper class that re-emits latest stream value for late subscribers
class StreamControllerReEmit<T> {
  final StreamController<T> _controller = StreamController<T>.broadcast();
  late T _latestValue;

  StreamControllerReEmit({required T initialValue}) {
    _latestValue = initialValue;
  }

  void add(T value) {
    _latestValue = value;
    _controller.add(value);
  }

  Stream<T> get stream async* {
    yield _latestValue;
    yield* _controller.stream;
  }

  T get latestValue => _latestValue;
  T get value => _latestValue;
}

/// Core Bluetooth communication manager
class BluetoothPrintPlus {
  static bool _initialized = false;

  static Future<void> _initFlutterBluePlus() async {
    if (_initialized) return;
    _initialized = true;

    _methodChannel.setMethodCallHandler((MethodCall call) async {
      _methodStream.add(call);
    });

    _state.listen((_) {});
  }

  /// Method channel to talk to native side
  static const MethodChannel _methodChannel = MethodChannel(
    "bluetooth_print_plus/methods",
  );

  /// Event channel for Bluetooth adapter state changes
  static const EventChannel _stateChannel = EventChannel(
    'bluetooth_print_plus/state',
  );

  static final StreamController<MethodCall> _methodStream =
      StreamController.broadcast();

  static final _scanResults = StreamControllerReEmit<List<BluetoothDevice>>(
    initialValue: [],
  );
  static final _isScanning = StreamControllerReEmit<bool>(initialValue: false);
  static final _connectState = StreamControllerReEmit<ConnectState>(
    initialValue: ConnectState.disconnected,
  );
  static final _blueState = StreamControllerReEmit<BlueState>(
    initialValue: BlueState.blueOn,
  );

  static Timer? _scanTimeout;
  static int? _stateNow;

  // Public Streams
  static Stream<List<BluetoothDevice>> get scanResults => _scanResults.stream;
  static Stream<bool> get isScanning => _isScanning.stream;
  static Stream<ConnectState> get connectState => _connectState.stream;
  static Stream<BlueState> get blueState => _blueState.stream;

  static bool get isScanningNow => _isScanning.latestValue;
  static bool get isConnected =>
      _connectState.latestValue == ConnectState.connected;
  static bool get isBlueOn => _blueState.latestValue == BlueState.blueOn;

  /// Start scanning for devices
  static Future<List<BluetoothDevice>> startScan({Duration? timeout}) async {
    await _initFlutterBluePlus();

    if (isScanningNow) await stopScan();

    await _scan(timeout: timeout).drain();
    return _scanResults.value;
  }

  /// Stop scanning
  static Future<void> stopScan() async {
    if (isScanningNow) {
      _isScanning.add(false);
      _scanTimeout?.cancel();
      await _methodChannel.invokeMethod('stopScan');
    }
  }

  /// Connect to a Bluetooth device
  static Future<void> connect(BluetoothDevice device) async {
    _connectState.add(ConnectState.connecting);
    await _methodChannel.invokeMethod('connect', device.toJson());
  }

  /// Disconnect
  static Future<void> disconnect() async {
    await _methodChannel.invokeMethod('disconnect');
  }

  /// Write bytes to printer
  static Future<void> write(Uint8List data) async {
    await _methodChannel.invokeMethod('write', {"data": data});
  }

  /// Received data from peripheral
  static Stream<Uint8List> get receivedData async* {
    yield* _methodStream.stream
        .where((m) => m.method == "ReceivedData")
        .map((m) => m.arguments);
  }

  static Stream<int> get _state async* {
    if (_stateNow == null) {
      var result = await _methodChannel.invokeMethod('state');
      _stateNow ??= result;
    }

    yield* _stateChannel.receiveBroadcastStream().map((s) {
      if (s == 0) {
        _blueState.add(BlueState.blueOn);
      } else if (s == 1) {
        _blueState.add(BlueState.blueOff);
      } else if (s == 2) {
        _connectState.add(ConnectState.connected);
      } else if (s == 3) {
        _connectState.add(ConnectState.disconnected);
      }
      return s;
    });
  }

  static Stream<BluetoothDevice> _scan({Duration? timeout}) async* {
    _isScanning.add(true);
    _scanResults.add([]);

    await _methodChannel
        .invokeMethod('startScan')
        .onError((_, __) => _isScanning.add(false));

    if (timeout != null) {
      _scanTimeout = Timer(timeout, stopScan);
    }

    yield* _methodStream.stream
        .where((m) => m.method == "ScanResult")
        .map((m) => m.arguments)
        .map((map) {
          final device = BluetoothDevice.fromJson(
            Map<String, dynamic>.from(map),
          );
          final List<BluetoothDevice> list = List.from(_scanResults.value);
          final index = list.indexWhere((e) => e.address == device.address);

          if (index != -1) {
            list[index] = device;
          } else {
            list.add(device);
          }

          _scanResults.add(list);
          return device;
        });
  }
}

/// Simple ESC/POS printer data builder
class PrintData {
  final List<int> _buffer = [];

  void text(
    String text, {
    AlignType align = AlignType.left,
    bool bold = false,
  }) {
    final alignCode = {
      AlignType.left: [0x1B, 0x61, 0],
      AlignType.center: [0x1B, 0x61, 1],
      AlignType.right: [0x1B, 0x61, 2],
    }[align]!;

    _buffer.addAll(alignCode);
    if (bold) _buffer.addAll([0x1B, 0x45, 1]);
    _buffer.addAll(text.codeUnits);
    _buffer.addAll([0x0A]);
    if (bold) _buffer.addAll([0x1B, 0x45, 0]);
  }

  void feed(int lines) => _buffer.addAll(List.filled(lines, 0x0A));
  void cut() => _buffer.addAll([0x1D, 0x56, 0x00]);

  Uint8List get bytes => Uint8List.fromList(_buffer);
}

enum AlignType { left, center, right }

class BluetoothPrintPage extends StatefulWidget {
  const BluetoothPrintPage({super.key});

  @override
  State<BluetoothPrintPage> createState() => _BluetoothPrintPageState();
}

class _BluetoothPrintPageState extends State<BluetoothPrintPage> {
  BluetoothDevice? _selectedDevice;
  List<BluetoothDevice> _devices = [];
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    await BluetoothPrintPlus.startScan(timeout: const Duration(seconds: 5));

    BluetoothPrintPlus.scanResults.listen((results) {
      setState(() => _devices = results);
    });

    BluetoothPrintPlus.connectState.listen((state) {
      setState(() => _isConnected = state == ConnectState.connected);
    });
  }

  Future<void> _connect(BluetoothDevice device) async {
    await BluetoothPrintPlus.connect(device);
    setState(() => _selectedDevice = device);
  }

  Future<void> _printTest() async {
    if (!_isConnected) return;

    final ticket = PrintData();
    ticket.text('=== TEST PRINT ===', align: AlignType.center, bold: true);
    ticket.text('Hello from Flutter');
    ticket.text('Total: \$25', align: AlignType.right, bold: true);
    ticket.feed(2);
    ticket.cut();

    await BluetoothPrintPlus.write(ticket.bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Print')),
      body: Column(
        children: [
          StreamBuilder<bool>(
            stream: BluetoothPrintPlus.isScanning,
            initialData: false,
            builder: (context, snapshot) {
              final scanning = snapshot.data ?? false;
              return ElevatedButton(
                onPressed: scanning
                    ? BluetoothPrintPlus.stopScan
                    : () => BluetoothPrintPlus.startScan(
                        timeout: const Duration(seconds: 5),
                      ),
                child: Text(scanning ? "Scanning..." : "Scan Devices"),
              );
            },
          ),
          Expanded(
            child: _devices.isEmpty
                ? Center(
                    child: Text(
                      "No devices found.\nTap 'Scan Devices' to search again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return ListTile(
                        title: Text(device.name ?? "Unknown"),
                        subtitle: Text(device.address ?? ""),
                        trailing: _selectedDevice?.address == device.address
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () => _connect(device),
                      );
                    },
                  ),
          ),
          if (_isConnected)
            ElevatedButton(
              onPressed: _printTest,
              child: const Text("Print Test"),
            ),
        ],
      ),
    );
  }
}
