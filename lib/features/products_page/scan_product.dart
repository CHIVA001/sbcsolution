import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import '../../routes/app_routes.dart';
import '../../widgets/build_app_bar.dart';
import 'controllers/product_controller.dart';

class ScanProduct extends StatefulWidget {
  const ScanProduct({super.key});

  @override
  State<ScanProduct> createState() => _ScanProductState();
}

class _ScanProductState extends State<ScanProduct> {
  final MobileScannerController _controller = MobileScannerController();
  final productsController = Get.put(ProductsController());
  bool isFlashOn = false;
  bool isProcessing = false;
  String? qrResult;
  bool _isScanned = false;

  void toggleFlash() async {
    try {
      await _controller.toggleTorch();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      debugPrint("Flash toggle failed: $e");
    }
  }

  Future<void> pickAndScanQR() async {
    setState(() => isProcessing = true);
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) return;

      String? qr = await QrCodeToolsPlugin.decodeFrom(image.path);
      if (qr != null) {
        showQRResult(qr);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No QR detected in image')),
        );
      }
    } catch (e) {
      log("Failed to scan QR from image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error scanning QR from image')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // void showQRResult(String qr) {
  //   setState(() => qrResult = qr);
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text("QR Code Found"),
  //       content: Text(qr),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Close"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void showQRResult(String qr) async {
    final product = productsController.products.firstWhereOrNull(
      (p) => p.code == qr || p.code.toString() == qr,
    );

    if (product != null) {
      if (mounted) setState(() => isProcessing = true);

      // Get.snackbar(
      //   'Product Found',
      //   product.name,
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: AppColors.primaryColor,
      //   colorText: Colors.white,
      // );
      // ✅ Small delay before navigating (let snackbar show)
      await Future.delayed(const Duration(milliseconds: 400));

      // ✅ Navigate first, THEN stop camera
      // await Get.to(() => ProfilePage());
      await Get.toNamed('${AppRoutes.product}/${product.id}');
      // ✅ Resume after returning
      _controller.start();

      if (mounted) setState(() => isProcessing = false);
    } else {
      Get.snackbar(
        'Not Found',
        'No product matches code: $qr',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scanBoxSize = size.width * 0.7 < 220
        ? 220
        : size.width * 0.7 > 350
        ? 350
        : size.width * 0.7;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: buildAppBar(
        title: 'Scan QR',
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// Camera View
          Positioned.fill(
            child: MobileScanner(
              controller: _controller,
              // onDetect: (capture) {
              //   if (isProcessing) return;
              //   final barcode = capture.barcodes.first;
              //   setState(() {
              //     isProcessing = true;
              //   });
              //   showQRResult(barcode.rawValue!);
              //   setState(() => isProcessing = false);
              // },
              onDetect: (capture) async {
                if (isProcessing) return;
                final barcode = capture.barcodes.first;
                if (barcode.rawValue == null) return;
                setState(() => isProcessing = true);

                showQRResult(barcode.rawValue!);

                await Future.delayed(const Duration(seconds: 2));
                setState(() => isProcessing = false);
              },
            ),
          ),

          /// Blurred overlay except scan box
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double screenWidth = constraints.maxWidth;
                final double screenHeight = constraints.maxHeight;
                final double left = (screenWidth - scanBoxSize) / 2;
                final double top = (screenHeight - scanBoxSize) / 2;

                return Stack(
                  children: [
                    ClipPath(
                      clipper: _HoleClipper(
                        left: left,
                        top: top,
                        size: scanBoxSize,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(color: Colors.black.withOpacity(0.2)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          /// Corner borders (camera clear area)
          Center(
            child: SizedBox(
              width: scanBoxSize,
              height: scanBoxSize,
              child: CustomPaint(
                painter: _CornerPainter(color: Colors.amber, strokeWidth: 4),
              ),
            ),
          ),

          /// Bottom content
          Positioned(
            bottom: size.height * 0.1,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Accepted",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: List.generate(5, (index) {
                    return CircleAvatar(
                      radius: size.width * 0.04, // responsive icons
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/icons/app_icon.png'),
                    );
                  }),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BottomButton(
                      onTap: toggleFlash,
                      icon: isFlashOn
                          ? Icons.flashlight_off
                          : Icons.flashlight_on,
                      label: "Flashlight",
                      iconSize: size.width * 0.06,
                    ),
                    SizedBox(width: size.width * 0.1),
                    _BottomButton(
                      onTap: pickAndScanQR,
                      icon: Icons.qr_code,
                      label: "Select QR",
                      iconSize: size.width * 0.06,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for scan box corners
class _CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CornerPainter({required this.color, this.strokeWidth = 4});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    const cornerLength = 24.0;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Clipper for blur hole
class _HoleClipper extends CustomClipper<Path> {
  final double left;
  final double top;
  final double size;

  _HoleClipper({required this.left, required this.top, required this.size});

  @override
  Path getClip(Size viewSize) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height));
    final hole = Path()
      ..addRRect(
        RRect.fromRectXY(Rect.fromLTWH(left, top, size, size), 16, 16),
      );
    return Path.combine(PathOperation.difference, path, hole);
  }

  @override
  bool shouldReclip(_HoleClipper oldClipper) => false;
}

/// Reusable bottom button
class _BottomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize;
  final void Function()? onTap;

  const _BottomButton({
    required this.icon,
    required this.label,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
              radius: iconSize + 6,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(icon, color: Colors.white, size: iconSize),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}
