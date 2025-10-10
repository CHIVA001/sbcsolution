import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/features/dashboad_page/time_leave_page/time_leave_model.dart';
import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/app_style.dart';
import 'time_leave_controller.dart';

class TimeLeavePage extends StatelessWidget {
  const TimeLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TimeLeaveController controller = Get.put(TimeLeaveController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: buildAppBar(
        title: MyText.timeLeave.tr,
        action: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => Get.toNamed(AppRoutes.addTimeLeave),
            color: AppColors.textPrimary,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.bgColorLight),
            ),
            icon: Icon(Icons.add, size: 24.0),
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: controller.getTimeLeave,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
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
                    onPressed: () => controller.getTimeLeave(),
                    label: Text('Try again'),
                  ),
                ],
              ),
            );
          }
          if (controller.errorMessage.value) {
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
                    onPressed: () => controller.getTimeLeave(),
                    label: Text('Try again'),
                  ),
                ],
              ),
            );
          }

          if (controller.timeLeaveList.isEmpty) {
            return Center(
              child: Text(
                'No leave requests found',
                style: theme.textTheme.titleMedium,
              ),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.all(16.0),
              itemCount: controller.timeLeaveList.length,
              itemBuilder: (context, index) {
                final leave = controller.timeLeaveList[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    duration: Duration(milliseconds: 500),
                    verticalOffset: 100,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildLeaveCard(context, leave, theme),
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

  Widget _buildLeaveCard(
    BuildContext context,
    TimeLeaveModel leave,
    ThemeData theme,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.withOpacity(0.3), width: 1),
      ),
      color: AppColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leave.employee ?? "N/A",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 22.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        leave.leaveName ?? 'N/A',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(leave.status ?? 'N/A', theme),
              ],
            ),
            const SizedBox(height: 20),
            // Leave details in a structured layout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    Icons.schedule_outlined,
                    'Time Shift',
                    leave.timeshift as String? ?? 'Not specified',
                    theme,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    Icons.calendar_today_outlined,
                    'Start Date',
                    _formatDate(leave.startDate as String? ?? ''),
                    theme,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    Icons.event_outlined,
                    'End Date',
                    _formatDate(leave.endDate as String? ?? ''),
                    theme,
                  ),
                  if ((leave.reason as String? ?? '').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      Icons.description_outlined,
                      'Reason',
                      leave.reason as String? ?? '',
                      theme,
                      isMultiline: true,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Duration indicator
            _buildDurationIndicator(leave, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, ThemeData theme) {
    Color color;
    IconData icon;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.access_time_rounded;
        break;
      case 'approved':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            status,
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    ThemeData theme, {
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
                maxLines: isMultiline ? null : 1,
                overflow: isMultiline ? null : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationIndicator(TimeLeaveModel leave, ThemeData theme) {
    try {
      final startDate = DateTime.parse(leave.startDate as String? ?? '');
      final endDate = DateTime.parse(leave.endDate as String? ?? '');
      final duration = endDate.difference(startDate).inDays + 1;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryLighter.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time, size: 18, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            Text(
              '$duration Day${duration > 1 ? 's' : ''}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
