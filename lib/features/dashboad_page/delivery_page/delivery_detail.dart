// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../core/themes/app_colors.dart';
// import '../../../core/themes/app_style.dart';
// import 'controller/delivery_controller.dart';

// class DeliveryDetailPage extends StatelessWidget {
//   const DeliveryDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final deliveryCtr = Get.find<DeliveryController>();
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         leading: IconButton(
//           onPressed: () {
//             // Get.offAll(() => BottomNavBarPage());
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: AppColors.backgroundColor,
//           ),
//         ),
//         title: Text(
//           'Delivery Detail',
//           style: TextStyle(color: AppColors.backgroundColor),
//         ),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (deliveryCtr.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final data = deliveryCtr.deliveryData.value;
//         if (data == null) {
//           return const Center(child: Text('No data available.'));
//         }

//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Card(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Reference: ${data.referenceNo}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text('Date: ${data.invoiceDate}', style: textdefualt()),
//                       //
//                       SizedBox(height: 24.0),
//                       Table(
//                         columnWidths: {
//                           0: FixedColumnWidth(150),
//                           1: FlexColumnWidth(),
//                         },
//                         border: TableBorder.all(),
//                         children: [
//                           _customTableRow("Customer", data.customer),
//                           _customTableRow("Delivered ID", data.deliveryId),
//                           _customTableRow("Zone ID", data.zoneId.toString()),
//                           _customTableRow("Status", data.status),
//                           // _customTableRow("Note", data.note),
//                           _customTableRow("Term Payment", data.paymentTerm),
//                           _customTableRow(
//                             "Sub Total",
//                             '\$${data.subTotal}',
//                             isHighlight: true,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 32.0),
//                 if (deliveryCtr.originalStatus.value != 'completed')
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Update Delivery Status',
//                         style: textdefualt().copyWith(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text("Pending"),
//                         value: "pending",
//                         groupValue: deliveryCtr.selectedStatus.value,
//                         onChanged: (value) {
//                           deliveryCtr.selectedStatus.value = value!;
//                         },
//                       ),
//                       RadioListTile<String>(
//                         title: const Text("Completed"),
//                         value: "completed",
//                         groupValue: deliveryCtr.selectedStatus.value,
//                         onChanged: (value) {
//                           deliveryCtr.selectedStatus.value = value!;
//                         },
//                       ),
//                       RadioListTile<String>(
//                         title: const Text("Partial"),
//                         value: "partial",
//                         groupValue: deliveryCtr.selectedStatus.value,
//                         onChanged: (value) {
//                           deliveryCtr.selectedStatus.value = value!;
//                         },
//                       ),
//                       SizedBox(height: 32.0),
//                       SizedBox(height: 32.0),

//                       Obx(() {
//                         final canUpdate =
//                             deliveryCtr.selectedStatus.value !=
//                             deliveryCtr.originalStatus.value;

//                         return SizedBox(
//                           width: double.infinity,
//                           height: 45.0,
//                           child: ElevatedButton(
//                             onPressed: canUpdate
//                                 ? () {
//                                     Get.dialog(
//                                       AlertDialog(
//                                         elevation: 0,
//                                         shape: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                         ),
//                                         title: const Text(
//                                           "Confirm Update",
//                                           textAlign: TextAlign.center,
//                                         ),

//                                         content: Text(
//                                           "Are you sure you want to update status to '${deliveryCtr.selectedStatus.value}'?",
//                                           style: textMeduim(),
//                                         ),
//                                         actions: [
//                                           TextButton(
//                                             style: ButtonStyle(
//                                               shape: WidgetStatePropertyAll(
//                                                 RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadiusGeometry.circular(
//                                                         8.0,
//                                                       ),
//                                                 ),
//                                               ),
//                                             ),
//                                             onPressed: () => Get.back(),
//                                             child: const Text("Cancel"),
//                                           ),
//                                           ElevatedButton(
//                                             onPressed: () async {
//                                               Get.back();
//                                               final success = await deliveryCtr
//                                                   .updateDeliveryStatus();
//                                               if (success) {
//                                                 Get.snackbar(
//                                                   "Success",
//                                                   "Status updated!",
//                                                   margin: EdgeInsets.only(
//                                                     bottom: 24,
//                                                     left: 16,
//                                                     right: 16,
//                                                   ),
//                                                   snackPosition:
//                                                       SnackPosition.BOTTOM,
//                                                   backgroundColor: Colors.green
//                                                       .withOpacity(0.8),
//                                                   colorText: Colors.white,
//                                                 );
//                                               } else {
//                                                 Get.snackbar(
//                                                   "Error",
//                                                   "Update failed",
//                                                   snackPosition:
//                                                       SnackPosition.BOTTOM,
//                                                   backgroundColor: Colors.red
//                                                       .withOpacity(0.8),
//                                                   colorText: Colors.white,
//                                                 );
//                                               }
//                                             },
//                                             child: Text("Yes, Update"),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                 : null,
//                             child: Text(
//                               !deliveryCtr.isLoading.value
//                                   ? 'Update'
//                                   : 'Loading...',
//                               style: textdefualt().copyWith(
//                                 color: AppColors.bgColorLight,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),

//                 if (deliveryCtr.originalStatus.value == 'completed')
//                   Center(
//                     child: Card(
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16.0,
//                           vertical: 8.0,
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.check_circle,
//                               color: AppColors.primaryColor,
//                             ),
//                             SizedBox(width: 8.0),
//                             Text(
//                               'Item Is Completed',
//                               style: textdefualt().copyWith(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 32.0),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   TableRow _customTableRow(
//     String label,
//     String? value, {
//     bool isHighlight = false,
//   }) {
//     return TableRow(
//       decoration: isHighlight
//           ? BoxDecoration(color: AppColors.primaryLight)
//           : null,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: Text(
//             label,
//             style: textdefualt().copyWith(
//               color: isHighlight ? AppColors.textLight : AppColors.textPrimary,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: Text(
//             value ?? 'N/A',
//             style: textdefualt().copyWith(
//               color: isHighlight ? AppColors.textLight : AppColors.textPrimary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


// // pending
// // Partial
// // Completed