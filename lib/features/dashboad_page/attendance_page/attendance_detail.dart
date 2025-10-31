import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_style.dart';
import '../../../widgets/build_app_bar.dart';

class AttendanceDetail extends StatelessWidget {
  final String fullName;
  final String checkInTime;
  final String checkOutTime;
  final String checkInDate;
  final String checkOutDate;
  final String checkInAddress;
  final String checkOutAddress;
  final String totalMinute;

  const AttendanceDetail({
    super.key,
    required this.fullName,
    required this.checkInTime,
    required this.checkOutTime,
    required this.checkInDate,
    required this.checkOutDate,
    required this.checkInAddress,
    required this.checkOutAddress,
    required this.totalMinute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Attendance Detail"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fullName, style: textBold().copyWith(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              '$checkInDate  -  $checkOutDate',
              style: textdefualt().copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total Time: $totalMinute',
              style: textdefualt().copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 20),
            TimelineTile(
              alignment: TimelineAlign.start,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: Colors.green,
                iconStyle: IconStyle(
                  iconData: Icons.check,
                  color: Colors.white,
                ),
              ),
              beforeLineStyle: const LineStyle(color: AppColors.successColor),
              endChild: _timelineCard(
                time: checkInTime,
                status: "Checked In",
                date: checkInDate,
                // image: checkInImage,
                address: checkInAddress,
                color: AppColors.successColor,
              ),
            ),

            ///  Checked Out Tile
            TimelineTile(
              alignment: TimelineAlign.start,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: Colors.red,
                iconStyle: IconStyle(
                  iconData: totalMinute != 'No Check-Out record found.'
                      ? Icons.check
                      : Icons.close,
                  color: Colors.white,
                ),
              ),
              beforeLineStyle: const LineStyle(color: Colors.green),
              endChild: _timelineCard(
                time: checkOutTime,
                status: "Checked Out",
                date: checkOutDate,
                // image: checkOutImage,
                address: checkOutAddress,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineCard({
    required String time,
    required String status,
    required String date,
    // required String image,
    required String address,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              backgroundColor: color.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: textdefualt().copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.darkGrey,
              ),
              const SizedBox(width: 4),
              Text(
                date,
                style: textdefualt().copyWith(color: AppColors.darkGrey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.image, size: 16, color: AppColors.darkGrey),
              const SizedBox(width: 4),
              // Text(image,
              //     style: const TextStyle(
              //         color: Colors.blue,
              //         decoration: TextDecoration.underline)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.darkGrey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  address,
                  style: textdefualt().copyWith(color: AppColors.darkGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
