
import '../../../core/themes/app_style.dart';
import '../../../widgets/build_app_bar.dart';
import '../../../widgets/build_row_icon_text.dart';
import '../../../widgets/build_table_row.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../invoices/services/add_device.dart';
import '../invoices/services/sunmi_print_service.dart';
import '/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class ConfirmCart extends StatelessWidget {
  ConfirmCart({super.key});
  final _cartCtr = Get.find<CartController>();
  final _userCtr = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    _cartCtr.cashierCtr.text = _userCtr.user.value?.username ?? '';
    return Scaffold(
      appBar: buildAppBar(title: 'Confitm Cart'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////////////
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          //
                          Expanded(
                            child: BuildRowIconText(
                              icon: RemixIcons.calendar_2_line,
                              text: '2025-10-18',
                            ),
                          ),
                          Expanded(
                            child: BuildRowIconText(
                              icon: RemixIcons.time_line,
                              text: '10:10 AM',
                            ),
                          ),
                        ],
                      ),
                      ////////////
                      SizedBox(height: 24.0),
                      Text('Info', style: textBold().copyWith(fontSize: 18.0)),
                      TextField(
                        controller: _cartCtr.customerCtr,
                        decoration: InputDecoration(
                          label: Text('Customer'),
                          hintText: 'Customer',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextField(
                          controller: _cartCtr.billerCtr,
                          decoration: InputDecoration(
                            hintText: 'Biller',
                            label: Text('Biller'),
                          ),
                        ),
                      ),

                      TextField(
                        controller: _cartCtr.cashierCtr,
                        decoration: InputDecoration(
                          hintText: 'Cashier',
                          label: Text('Cashier'),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        'Payments',
                        style: textBold().copyWith(fontSize: 18.0),
                      ),
                      TextField(
                        controller: _cartCtr.payment,
                        decoration: InputDecoration(
                          hintText: 'Payment',
                          label: Text('Payment'),
                        ),
                      ),

                      //  table list products
                      SizedBox(height: 24.0),
                      Center(
                        child: Text(
                          'Invoice',
                          style: textBold().copyWith(
                            fontSize: 20.0,
                            decoration: TextDecoration.underline,
                          ),

                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Table(
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: {
                          0: FlexColumnWidth(3), // Name
                          1: FlexColumnWidth(1.1), // QTY
                          2: FlexColumnWidth(1.2), // Unit
                          3: FlexColumnWidth(1.7), // Discount
                          4: FlexColumnWidth(2), // Amount
                        },
                        children: [
                          // Header
                          BuildTableRow.build(
                            bgColor: AppColors.primaryColor,
                            textColor: AppColors.textLight,
                            name: 'Name',
                            qty: 'QTY',
                            unit: 'Unit',
                            discount: 'Discount',
                            amount: 'Amount',
                          ),
                          // body
                          ..._cartCtr.cartItems.map((item) {
                            return BuildTableRow.build(
                              name: item.name,
                              qty: item.qty.toString(),
                              unit: 'Unit',
                              discount: '0%',
                              amount: '\$${item.total}',
                            );
                          }),
                        ],
                      ),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  // '\$${_cartCtr.cartItems.fold<double>(0, (sum, item) => sum + (item.price * item.qty)).toStringAsFixed(2)}',
                                  '\$${_cartCtr.grandTotal}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // footer
                      SizedBox(height: 16.0),
                      Center(
                        child: Text(
                          'Thank you for shopping.',
                          style: textdefualt().copyWith(
                            fontSize: 14.0,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () => Get.to(() => BluetoothPrintPage()),
                        icon: Icon(Icons.add),
                        label: Text('Add Device'),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await SunmiPrintService.initPrinter();
                          final cashier = _cartCtr.cashierCtr.text;
                          // prepare data
                          final items = _cartCtr.cartItems.map((item) {
                            return {
                              'name': item.name,
                              'qty': item.qty,
                              'amount': item.total,
                            };
                          }).toList();

                          await SunmiPrintService.printInvoice(
                            company:
                                '${_userCtr.user.value?.company.toUpperCase()}',
                            customer: _cartCtr.customerCtr.text,
                            biller: _cartCtr.billerCtr.text,
                            cashier: cashier,
                            items: items,
                            total: double.parse(_cartCtr.grandTotal.toString()),
                            grandTotal: double.parse(
                              _cartCtr.grandTotal.toString(),
                            ),
                            exchangeRate: 4000.0,
                            paymentMethod: _cartCtr.payment.text,
                          );

                          Get.back();
                          Get.back();
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text('Pay & Print'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
