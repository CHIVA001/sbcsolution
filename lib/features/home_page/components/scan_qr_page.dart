import 'dart:developer';
import 'package:app_settings/app_settings.dart';
import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_style.dart';
import '../../dashboad_page/attendance_page/controllers/attendance_controller.dart';
import '../../dashboad_page/attendance_page/controllers/shift_controller.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final MobileScannerController _scannerController = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.unrestricted,
    detectionTimeoutMs: 250,
  );

  // final _companyCtr = Get.find<AuthController>();
  final attCtr = Get.find<AttendanceController>();
  final _shifCtr = Get.find<ShiftController>();
  final _authCtr = Get.find<AuthController>();
  bool _isScanerSuccess = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
  }

  void handleScanQrcode() async {
    setState(() {
      _isScanerSuccess = false;
    });
    if (_shifCtr.isLoading.value) return;
    Position? pos = await _determinePosition();
    if (pos == null) {
      setState(() {
        _isScanerSuccess = false;
      });
      return;
    }
    String longitute = '${pos.longitude}';
    String latitute = '${pos.latitude}';
    if (latitute.isNotEmpty || longitute.isNotEmpty) {
      // await _shifCtr.handleQrScanner(latitute: latitute, longitute: longitute);
      await _shifCtr.handleAttendance(
        latitute: pos.latitude.toString(),
        longitute: pos.longitude.toString(),
        fromQr: true, // qr mode
      );

      log('latitute: $latitute');
      log('longitute: $longitute');
    }
    setState(() {
      _isScanerSuccess = false;
    });
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.defaultDialog(
        title: 'Location',
        radius: 8,
        titleStyle: textBold().copyWith(fontSize: 24.0),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Please enable your location service and try again.',
                style: textdefualt(),
              ),
            ),
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Ok",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.defaultDialog(
          title: 'Location Permission',
          titlePadding: EdgeInsets.symmetric(vertical: 8.0),
          content: Column(
            children: [
              Text(
                'Location permission denied. Please allow location access to use this feature.',
              ),
            ],
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Ok",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(
            'Location permission has been permanently denied. '
            'Please enable it manually in Settings.',
            style: textMeduim(),
          ),
          actions: [
            TextButton(
              onPressed: () => AppSettings.openAppSettings(),
              child: Text('Settings', style: textdefualt()),
            ),
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text(
                'OK',
                style: textdefualt().copyWith(color: AppColors.textLight),
              ),
            ),
          ],
        ),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _authCtr
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Scan Attendance",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0.3,
      ),
      body: Obx(() {
        final label = _shifCtr.shiftId.isEmpty ? 'Check-in' : 'Check-out';
        if (_shifCtr.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryDarker,
              strokeWidth: 1.5,
            ),
          );
        }
        return Stack(
          children: [
            Positioned(
              child: MobileScanner(
                controller: _scannerController,
                onDetect: (capture) async {
                  if (_isScanerSuccess) return;
                  final List<Barcode> barcodes = capture.barcodes;

                  if (barcodes.isNotEmpty) {
                    final String? scannedQr = barcodes.first.rawValue;
                    // final String expectedQr = _shifCtr.qrCode;
                    final qr = _authCtr.companies.first.qrCode;
                    final String expectedQr = qr!;

                    log("Scanned QR: $scannedQr");
                    log("Expected QR: $expectedQr");
                    if (scannedQr != null && scannedQr == expectedQr) {
                      setState(() => _isScanerSuccess = true);
                      _scannerController.stop();

                      final pos = await _determinePosition();
                      if (pos != null) {
                        String longitute = '${pos.longitude}';
                        String latitute = '${pos.latitude}';
                        //  Use unified controller method
                        if (latitute.isNotEmpty || longitute.isNotEmpty) {
                          await _shifCtr.handleAttendance(
                            latitute: pos.latitude.toString(),
                            longitute: pos.longitude.toString(),
                            fromQr: true,
                          );
                          log('latitute: $latitute');
                          log('longitute: $longitute');
                        }
                      } else {
                        setState(() => _isScanerSuccess = true);
                      }
                    }
                  }
                },
              ),
            ),

            /// Overlay design
            Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  "Align the QR code within the frame",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Please Scan $label Your attendance",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                /// Scanner frame
                Expanded(
                  child: Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  (280 - 4) * _controller.value,
                                ),
                                child: Container(
                                  height: 4,
                                  width: 280,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.greenAccent.withOpacity(0.9),
                                        Colors.green.withOpacity(0.6),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Bottom control buttons
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildControlButton(
                        icon: Icons.flash_on,
                        label: "Flash",
                        onTap: () => _scannerController.toggleTorch(),
                      ),
                      _buildControlButton(
                        icon: Icons.qr_code,
                        label: "My QR",
                        onTap: () {
                          // TODO: Navigate to user QR
                        },
                      ),
                      _buildControlButton(
                        icon: Icons.history,
                        label: "History",
                        onTap: () {
                          // TODO: Navigate to history
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
