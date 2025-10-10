import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/dashboad_page/day_off_page/day_off_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/day_off_page/day_off_detail.dart';
import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DayOffPage extends StatelessWidget {
  DayOffPage({super.key});

  final controller = Get.find<DayOffController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: MyText.dayOff.tr,
        action: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => Get.toNamed(AppRoutes.addDayoff),
            color: AppColors.textPrimary,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.bgColorLight),
            ),
            icon: Icon(Icons.add, size: 24.0),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorNetwork.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 64.0, color: AppColors.darkGrey),
                Text(
                  'Network not Available',
                  style: textMeduim().copyWith(color: AppColors.darkGrey),
                ),
                SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchDayOff(),
                  label: Text('Try again'),
                ),
              ],
            ),
          );
        }
        if (controller.hasError.value) {
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
                  style: textMeduim().copyWith(color: AppColors.darkGrey),
                ),
                SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchDayOff(),
                  label: Text('Try again'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchDayOff();
          },
          child: AnimationLimiter(
            child: ListView.separated(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: controller.dayOffList.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                final data = controller.dayOffList[index];
                final formatDayOff = DateTime.parse('${data.dayOff}');
                final dateDayOff = DateFormat(
                  'dd MMM yyyy',
                ).format(formatDayOff);
                final description = data.description!.isEmpty
                    ? 'N/A'
                    : data.description;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    duration: Duration(milliseconds: 500),
                    verticalOffset: 100,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => Get.to(
                          () => DayOffDetail(dayOff: data),
                          transition: Transition.upToDown,
                        ),
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.fromLTRB(
                            16,
                            index == 0 ? 16 : 0,
                            16,
                            0,
                          ),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(
                              color: AppColors.successColor.withOpacity(0.3),
                            ),
                          ),
                          color: AppColors.backgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryColor
                                      .withOpacity(0.2),
                                  radius: 35.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${formatDayOff.day}',
                                        style: textBold(),
                                      ),
                                      Text(
                                        DateFormat.MMM().format(formatDayOff),
                                        style: textSmaill(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            data.fullName,
                                            style: textBold().copyWith(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.date_range_outlined,
                                                  color: AppColors.primaryDark,
                                                  size: 15,
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  'Day Off',
                                                  style: textSmaill().copyWith(
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      _buildTextRow(
                                        icon: Icons.badge_outlined,
                                        title: 'Employee ID',
                                        value: '${data.employeeId}',
                                      ),
                                      _buildTextRow(
                                        icon: Icons.calendar_today_outlined,
                                        title: 'Date',
                                        value: dateDayOff,
                                      ),
                                      _buildTextRow(
                                        icon: Icons.description_outlined,
                                        title: 'Description',
                                        value: description!,
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: AppColors.darkGrey,
                                  ),
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
          ),
        );
      }),
    );
  }

  Widget _buildTextRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.darkGrey, size: 16.0),
          SizedBox(width: 8.0),
          Text(
            '$title: ',
            style: textMeduim().copyWith(color: AppColors.darkGrey),
          ),
          Flexible(
            child: Text(
              value,
              style: textMeduim().copyWith(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
