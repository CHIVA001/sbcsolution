import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/dashboad_page/sale/controller/sale_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/sale/sale_detail.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_colors.dart';

class SalesPage extends StatelessWidget {
  SalesPage({super.key});

  final _saleCtr = Get.find<SaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: buildAppBar(title: MyText.sales.tr),
      body: RefreshIndicator(
        onRefresh: () async => _saleCtr.fetchSales(),
        child: Obx(() {
          final sales = _saleCtr.sales;
          if (_saleCtr.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (sales.isEmpty) {
            return const Center(
              child: Text(
                'Sale data is Empty!.',
                style: TextStyle(color: AppColors.textLight),
              ),
            );
          }
          if (_saleCtr.isError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 32.0,
                    color: AppColors.dangerColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 8.0),
                  Text('Error something!', style: textdefualt()),
                  SizedBox(height: 24.0),
                  ElevatedButton.icon(
                    onPressed: () => _saleCtr.fetchSales(),
                    label: Text('Try again'),
                  ),
                ],
              ),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];
                final color = listColors[sale.customer[0].toUpperCase()];

                // Format currency + date
                final currencyFormat = NumberFormat.currency(
                  locale: 'en_US',
                  symbol: '\$',
                );
                final formattedTotal = currencyFormat.format(sale.grandTotal);
                final formattedDate = DateFormat(
                  'MMM d, yyyy',
                ).format(DateTime.parse(sale.date));

                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    duration: Duration(milliseconds: 800),
                    verticalOffset: 100,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => Get.to(
                          () => SaleDetailPage(sale: sale),
                          transition: Transition.upToDown,
                        ),
                        child: _saleCard(
                          customer: sale.customer,
                          pickNo: sale.pickNo,
                          total: formattedTotal,
                          status: sale.paymentStatus,
                          date: formattedDate,
                          bgColor: color!.withOpacity(0.1),
                          sColor: color,
                          nameColor: color,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _saleCard({
    required String customer,
    required String pickNo,
    required String total,
    required String status,
    required String date,
    required Color bgColor,
    required Color nameColor,
    required Color sColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Pick No: $pickNo',
                    style: textMeduim().copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.5),

            _infoRow(Icons.person, 'Customer', customer, nameColor),
            _infoRow(Icons.calendar_today, 'Date', date, AppColors.textPrimary),
            _infoRow(
              Icons.money,
              'Total',
              total,
              Colors.teal.shade700,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
    Color valueColor, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey.shade400),
          const SizedBox(width: 8),
          Text(
            '$title:',
            style: textdefualt().copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: textdefualt().copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return Colors.green.shade600;
      case 'pending':
        return Colors.orange.shade600;
      case 'due':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
