import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/dashboad_page/report_page/report_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/report_page/report_detail.dart';
import 'package:cyspharama_app/widgets/build_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/build_app_bar.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
    return Scaffold(
      appBar: buildAppBar(title: MyText.report.tr),
      body: RefreshIndicator(
        onRefresh: () => controller.getReport(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.isError.value) {
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
                    onPressed: () => controller.getReport(),
                    label: Text('Try again'),
                  ),
                ],
              ),
            );
          }
          if (controller.reportSalary.isEmpty) {
            return Center(
              child: Text(
                'Not Report',
                style: textdefualt().copyWith(
                  color: AppColors.darkGrey,
                  fontSize: 20.0,
                ),
              ),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.all(16.0),
              itemCount: controller.reportSalary.length,
              itemBuilder: (context, index) {
                final data = controller.reportSalary[index];
                // format month to text
                final date = DateTime(
                  int.parse(data.year!),
                  int.parse(data.month!),
                );
                final month = DateFormat('MMM').format(date);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    duration: Duration(milliseconds: 800),
                    verticalOffset: 100,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => Get.to(
                          () => ReportDetail(data: data),
                          transition: Transition.upToDown,
                        ),
                        child: BuildCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.fullName,
                                        style: textBold().copyWith(
                                          fontSize: 20.0,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    //
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.3),

                                        borderRadius: BorderRadius.circular(
                                          16.0,
                                        ),
                                      ),
                                      child: Text(
                                        '${data.paymentStatus}',
                                        style: textMeduim().copyWith(
                                          color: AppColors.primaryDark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),

                                Divider(),
                                // date
                                buildRow(
                                  icon: Icons.calendar_month,
                                  title: 'Date',
                                  value: '$month ${data.year}',
                                ),
                                buildRow(
                                  icon: Icons.attach_money_sharp,
                                  title: 'Gross Salary',
                                  value: '\$${data.grossSalary}',
                                ),
                                buildRow(
                                  icon: Icons.payment,
                                  title: 'Net Pay',
                                  value: '\$${data.netPay}',
                                ),
                              ],
                            ),
                          ),
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

  Widget buildRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.darkGrey),
          SizedBox(width: 8.0),
          Text(title, style: textdefualt()),
          Spacer(),
          Text(value, style: textdefualt()),
        ],
      ),
    );
  }
}
