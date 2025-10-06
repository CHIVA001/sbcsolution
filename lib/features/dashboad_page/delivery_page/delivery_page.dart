import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/features/dashboad_page/delivery_page/controller/delivery_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/delivery_page/scan_dispatch_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/localization/my_text.dart';
import '../../../widgets/build_app_bar.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryCtr = Get.find<DeliveryController>();
    return Scaffold(
      appBar: buildAppBar(title: MyText.delivery.tr),
      // body: Obx(() {
      //   if (deliveryCtr.isLoading.value) {
      //     return const Center(child: CircularProgressIndicator());
      //   }

      //   final data = deliveryCtr.deliveryData.value;
      //   if (data == null) {
      //     return const Center(child: Text('No data available.'));
      //   }

      //   return Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Card(
      //       elevation: 4,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //       child: Container(
      //         width: double.infinity,
      //         padding: const EdgeInsets.all(16),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Text(
      //               'Reference: ${data.referenceNo}',
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 18,
      //               ),
      //             ),
      //             const SizedBox(height: 8),
      //             Text('Date: ${data.date}'),
      //             Text('Status: ${data.status}'),
      //             Text('Total: \$${data.grandTotal}'),
      //             Text('Delivered by: ${data.deliveredBy}'),
      //             Text('Zone ID: ${data.zoneId}'),
      //           ],
      //         ),
      //       ),
      //     ),
      //   );
      // }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ScanDispatchPage());
        },
        child: Icon(Icons.qr_code_scanner, color: AppColors.bgColorLight),
      ),
    );
  }
}
