import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/dashboad_page/attendance_page/models/attenace_model.dart';
import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controllers/attendance_controller.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _controller = Get.find<AttendanceController>();

  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    _controller.getCheckInOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        onPressed: () => Get.offAllNamed(AppRoutes.navBar),
        title: MyText.attendance.tr,
        action: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () => _selectDate(context),
            icon: Icon(
              Icons.date_range,
              size: 26.0,
              color: AppColors.textLight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.checkInOutData.isEmpty) {
          return Center(
            child: Text(
              'Not Attendance',
              style: textdefualt().copyWith(
                color: AppColors.darkGrey,
                fontSize: 20.0,
              ),
            ),
          );
        }
        if (_controller.isError.value) {
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
                  onPressed: () => _controller.getCheckInOut(),
                  label: Text('Try again'),
                ),
              ],
            ),
          );
        }

        List<CheckInOutModel> attendanceList = _controller.checkInOutData;

        if (_selectedDate != null) {
          attendanceList = attendanceList.where((record) {
            final recordDate = DateTime.tryParse(record.checkIn);
            if (recordDate == null) return false;
            return recordDate.year == _selectedDate!.year &&
                recordDate.month == _selectedDate!.month &&
                recordDate.day == _selectedDate!.day;
          }).toList();
        }

        // Sort by check-in descending
        attendanceList.sort((a, b) {
          final aDate = DateTime.tryParse(a.checkIn) ?? DateTime(2000);
          final bDate = DateTime.tryParse(b.checkIn) ?? DateTime(2000);
          return bDate.compareTo(aDate);
        });
        if (attendanceList.isEmpty) {
          final formatDelectedDate = _selectedDate != null
              ? DateFormat('dd-MMM-yyyy').format(_selectedDate!)
              : 'N/A';

          final empId = _controller.checkInOutData.isNotEmpty
              ? _controller.empId
              : 'N/A';

          return _buildEmptyState(empId, formatDelectedDate);
        }

        return RefreshIndicator(
          onRefresh: _controller.getCheckInOut,
          child: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final item = attendanceList[index];

                final checkInDate = DateTime.tryParse(item.checkIn);
                final checkOutDate = (item.checkOut != "0000-00-00 00:00:00")
                    ? DateTime.tryParse(item.checkOut)
                    : null;

                final formattedCheckInDate = checkInDate != null
                    ? DateFormat('dd-MMM-yyyy').format(checkInDate)
                    : "== ** ==";
                final formattedCheckInTime = checkInDate != null
                    ? DateFormat('hh:mm:ss a').format(checkInDate)
                    : "== ** ==";

                final formattedCheckOutDate = checkOutDate != null
                    ? DateFormat('dd-MMM-yyyy').format(checkOutDate)
                    : "== ** ==";

                final formattedCheckOutTime = checkOutDate != null
                    ? DateFormat('hh:mm:ss a').format(checkOutDate)
                    : "== ** ==";
                final totalTime = item.shiftTotalTime != null
                    ? '${item.shiftTotalTime} mn'
                    : '== ** ==';

                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    duration: Duration(milliseconds: 500),
                    verticalOffset: 100,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onLongPress: () async {
                          final checkinLat = item.checkinLocation?.latitude;
                          final checkinLng = item.checkinLocation?.longitude;
                          final checkoutLat = item.checkoutLocation?.latitude;
                          final checkoutLng = item.checkoutLocation?.longitude;

                          // Get readable addresses only if lat/lng exist
                          final checkinAddress =
                              (checkinLat != null && checkinLng != null)
                              ? await _controller.getAddressFromLatLng(
                                  checkinLat,
                                  checkinLng,
                                )
                              : "You not Check-In";

                          final checkoutAddress =
                              (checkoutLat != null && checkoutLng != null)
                              ? await _controller.getAddressFromLatLng(
                                  checkoutLat,
                                  checkoutLng,
                                )
                              : "You not Check-Out";

                          final totalMinute = item.shiftTotalTime != null
                              ? '${item.shiftTotalTime} minute'
                              : 'You not Check-out';

                          Get.defaultDialog(
                            title: 'Attendance Detail',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Divider(),
                                Text('Total Time', style: textMeduim()),
                                Text(totalMinute),
                                Divider(),
                                Text('Check In At', style: textMeduim()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    checkinAddress,
                                    style: textMeduim(),
                                  ),
                                ),
                                Divider(),
                                Text('Check Out At', style: textMeduim()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    checkoutAddress,
                                    style: textMeduim(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                        child: Card(
                          color: AppColors.textLight,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    radius: 24.0,
                                    backgroundColor: AppColors.lightGrey,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                  title: Text(item.fullName, style: textBold()),
                                  subtitle: Text(
                                    'ID: ${item.employeeId}',
                                    style: textdefualt().copyWith(
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Code: ${item.empcode}',
                                        style: textBold().copyWith(
                                          color: AppColors.warningColor,
                                        ),
                                      ),
                                      Text(
                                        'Total time: $totalTime',
                                        style: textBold().copyWith(
                                          color: AppColors.warningColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Text(
                                  'Check-In',
                                  style: textBold().copyWith(
                                    fontSize: 18.0,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                TextRow(
                                  icon: Icons.date_range,
                                  label: 'Date: ',
                                  value: formattedCheckInDate,
                                  valueColor: AppColors.successColor,
                                ),
                                TextRow(
                                  icon: Icons.access_time,
                                  label: 'Time: ',
                                  value: formattedCheckInTime,
                                  valueColor: AppColors.successColor,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Check-Out',
                                  style: textBold().copyWith(
                                    fontSize: 18.0,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                TextRow(
                                  icon: Icons.date_range,
                                  label: 'Date: ',
                                  value: formattedCheckOutDate,
                                  valueColor: AppColors.dangerColor,
                                ),
                                TextRow(
                                  icon: Icons.access_time,
                                  label: 'Time: ',
                                  value: formattedCheckOutTime,
                                  valueColor: AppColors.dangerColor,
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

  Widget _buildEmptyState(String empId, String? selectedDate) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No attendance for',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('$selectedDate', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(
            'Employee ID: $empId',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class TextRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  const TextRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 22.0, color: AppColors.darkGrey),
          const SizedBox(width: 4.0),
          Text(label, style: textdefualt().copyWith(color: AppColors.darkGrey)),
          const SizedBox(width: 8.0),
          // Spacer(),
          Text(
            value,
            style: textdefualt().copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
