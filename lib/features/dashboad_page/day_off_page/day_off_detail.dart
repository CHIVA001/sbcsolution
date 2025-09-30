import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/day_off_page/day_off_model.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DayOffDetail extends StatelessWidget {
  DayOffDetail({super.key, required this.dayOff});

  final DayOffData dayOff;

  final _companyCtr = Get.find<AuthController>();

  // Helper method for consistent cell styling

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(title: 'Day Off Detail'),
      body: Obx(() {
        if (_companyCtr.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_companyCtr.companies.isEmpty) {
          return const Center(child: Text('No company information found.'));
        }

        final data = _companyCtr.companies.first;

        final description =
            dayOff.description != null && dayOff.description!.isNotEmpty
            ? dayOff.description
            : "== ==";

        String formatDay;
        try {
          formatDay = DateFormat(
            'dd-MMM-yyyy',
          ).format(DateTime.parse('${dayOff.dayOff}'));
        } catch (e) {
          formatDay = 'Invalid Date';
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Company Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CachedNetworkImage(
                  width: size.width * 0.4,
                  imageUrl: data.logo.toString(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 50, color: Colors.red),
                  placeholder: (context, url) => const SizedBox.shrink(),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Text(
                data.company.toString(),
                style: textBold().copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                data.name.toString(),
                style: textBold().copyWith(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              // Address
              Text(
                data.address?.replaceAllMapped(
                      RegExp(r'<[^>]*>|&[^;]+;'),
                      (match) => '',
                    ) ??
                    'No address provided',
                style: textdefualt().copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              // Phone
              Text(
                'Tel: ${data.phone ?? 'N/A'}',
                style: textdefualt().copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              Text(
                'ថ្ងៃឈប់សម្រាក',
                style: textBold().copyWith(
                  fontSize: 22.0,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Day Off',
                style: textBold().copyWith(
                  fontSize: 22.0,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15.0),

              // Day Off Table
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(60),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                },
                border: TableBorder.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      // Rounded top corners
                    ),
                    children: [
                      _buildTableCell(
                        'ID',
                        style: textBold().copyWith(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        bgColor: AppColors.primaryColor,
                      ),
                      _buildTableCell(
                        'Date',
                        style: textBold().copyWith(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        bgColor: AppColors.primaryColor,
                      ),
                      _buildTableCell(
                        'Name',
                        style: textBold().copyWith(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        bgColor: AppColors.primaryColor,
                      ),
                      _buildTableCell(
                        'Description',
                        style: textBold().copyWith(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        bgColor: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  // Day Off Data Row
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade50),
                    children: [
                      _buildTableCell(dayOff.employeeId?.toString() ?? 'N/A'),
                      _buildTableCell(formatDay),
                      _buildTableCell(dayOff.fullName),
                      _buildTableCell(
                        description ?? 'N/A',
                        textAlign: dayOff.description == ''
                            ? TextAlign.center
                            : TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Text('Thank you', style: textdefualt()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTableCell(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    Color? bgColor,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        color: bgColor,
        child: Text(
          text,
          style: style ?? textdefualt().copyWith(fontSize: 14), // Default style
          textAlign: textAlign ?? TextAlign.center,
        ),
      ),
    );
  }
}
