import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'controller/delivery_controller.dart';

class ScanDispatchPage extends StatefulWidget {
  const ScanDispatchPage({super.key});

  @override
  State<ScanDispatchPage> createState() => _ScanDispatchPageState();
}

class _ScanDispatchPageState extends State<ScanDispatchPage> {
  bool _isScanning = true;
  bool _flashOn = false;

  late final MobileScannerController _scannerController;
  final controller = Get.put(DeliveryController());
  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null) {
      setState(() {
        _isScanning = false;
      });

      _scannerController.stop();

      final success = await controller.fetchDispatchFromQr(code);

      if (success) {
        Get.to(() => const DeliveryDetailPage())?.then((_) {
          if (mounted) {
            _scannerController.start();
            setState(() {
              _isScanning = true;
            });
          }
        });
      } else {
        _scannerController.start();
        setState(() {
          _isScanning = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mobile Scanner
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleDetection,
          ),

          _ScannerOverlay(isScanning: _isScanning),

          // Back Button (Original)
          Positioned(
            top: 60,
            left: 16.0,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  AppColors.lightGrey.withOpacity(0.1),
                ),
              ),
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.bgColorLight,
                size: 24.0,
              ),
            ),
          ),
          // Flash Button
          Positioned(
            top: 60,
            right: 16.0,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  AppColors.lightGrey.withOpacity(0.1),
                ),
              ),
              icon: Icon(
                _flashOn ? Icons.flash_on : Icons.flash_off,
                color: _flashOn ? Colors.yellow : AppColors.bgColorLight,
                size: 28,
              ),
              onPressed: () {
                _scannerController.toggleTorch();
                setState(() {
                  _flashOn = !_flashOn; // update UI
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  final bool isScanning;
  const _ScannerOverlay({required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              children: [
                _Corner(Alignment.topLeft),
                _Corner(Alignment.topRight),
                _Corner(Alignment.bottomLeft),
                _Corner(Alignment.bottomRight),
              ],
            ),
          ),

          const SizedBox(height: 64),

          // Instructions Text
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: isScanning
                ? const Text(
                    'Align QR Code in the frame to scan dispatch.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                : Obx(() {
                    final deliveryCtr = Get.find<DeliveryController>();
                    return Text(
                      deliveryCtr.isLoading.value
                          ? 'Loading Dispatch...'
                          : 'Scan Complete.',
                      style: const TextStyle(
                        color: AppColors.warningColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final Alignment alignment;
  const _Corner(this.alignment);

  @override
  Widget build(BuildContext context) {
    final bool isTop = alignment.y == -1;
    final bool isLeft = alignment.x == -1;

    return Align(
      alignment: alignment,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
