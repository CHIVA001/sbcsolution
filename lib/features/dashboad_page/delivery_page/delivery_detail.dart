// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'controller/delivery_controller.dart';

// class DeliveryDetailPage extends StatelessWidget {
//    DeliveryDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final deliveryCtr = Get.find<DeliveryController>();
//     return Scaffold(
//       appBar: AppBar(title: const Text('DeliveryController')),
//       body: Obx(() {
//         if (deliveryCtr.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final data = deliveryCtr.deliveryData.value;
//         if (data == null) {
//           return const Center(child: Text('No data available.'));
//         }

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Reference: ${data.referenceNo}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text('Date: ${data.date}'),
//                   Text('Status: ${data.status}'),
//                   Text('Total: \$${data.grandTotal}'),
//                   Text('Delivered by: ${data.deliveredBy}'),
//                   Text('Zone ID: ${data.zoneId}'),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// class StatelessWidget {
// }
