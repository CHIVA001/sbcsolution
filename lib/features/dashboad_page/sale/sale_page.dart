import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/my_text.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_style.dart';
import '../../../widgets/build_app_bar.dart';
import 'controller/sale_controller.dart';
import 'sale_detail.dart';

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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
              height: 40.0,
              // color: Colors.amber,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.darkGrey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: [
                  _tabButton(label: 'All', tabKey: 'all'),
                  _tabButton(label: 'Order', tabKey: 'order'),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final sales = _saleCtr.sales;
                if (_saleCtr.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (_saleCtr.errorNetwork.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 64.0,
                          color: AppColors.darkGrey,
                        ),
                        Text(
                          'Network not Available',
                          style: textMeduim().copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton.icon(
                          onPressed: () => _saleCtr.fetchSales(),
                          label: Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                }
                if (_saleCtr.isError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_outlined,
                          size: 64.0,
                          color: AppColors.dangerColor.withOpacity(0.5),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Error Service: 500',
                          style: textMeduim().copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton.icon(
                          onPressed: () => _saleCtr.fetchSales(),
                          label: Text('Refresh'),
                        ),
                      ],
                    ),
                  );
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
                          label: Text('Refresh'),
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
                                total: sale.grandTotal,
                                status: sale.saleStatus,
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget _saleCard({
    required String customer,
    required String pickNo,
    required double total,
    required String status,
    required String date,
    required Color bgColor,
    required Color nameColor,
    required Color sColor,
  }) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final formattedTotal = currencyFormat.format(total);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightGrey),
      ),
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

            _infoRow(Icons.person, 'Customer', customer, AppColors.primaryRed),
            _infoRow(Icons.calendar_today, 'Date', date, AppColors.textPrimary),
            _infoRow(
              Icons.money,
              'Total',
              formattedTotal,
              total > 0 ? Colors.teal.shade700 : AppColors.dangerColor,
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
                // color: Colors.blueGrey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  Widget _tabButton({required String label, required String tabKey}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _saleCtr.changeTab(tabKey),
        child: Obx(() {
          final bool isActive = _saleCtr.selectedTab.value == tabKey;
          return Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? AppColors.accentColor : Colors.transparent,
              border: Border(right: BorderSide(color: AppColors.darkGrey)),
            ),
            child: Text(
              label,
              style: textMeduim().copyWith(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return Colors.green.shade600;
      case 'approved':
        return Colors.blue;
      case 'pending':
        return Colors.orange.shade600;
      case 'returned':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
