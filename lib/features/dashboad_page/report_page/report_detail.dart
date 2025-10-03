import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/report_page/report_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/report_page/report_model.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:cyspharama_app/widgets/build_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportDetail extends StatelessWidget {
  ReportDetail({super.key, required this.data});
  final SalaryData data;
  final _companyCtr = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(title: 'Report Detail'),

      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Obx(
            () => SizedBox(
              height: 520,
              child: Card(
                color: AppColors.bgColorLight,
                margin: EdgeInsets.all(16.0),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _companyCtr.companies.length,
                  itemBuilder: (context, index) {
                    final item = _companyCtr.companies[index];
                    final colorStatus = data.status! == 'approved'
                        ? Colors.cyan
                        : Colors.amberAccent;
                    final colorStatusPayment = data.paymentStatus! == 'paid'
                        ? Colors.green
                        : Colors.cyan;
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: "${item.logo}",
                            width: size.width * 0.3,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.image),
                            placeholder: (context, url) => SizedBox.shrink(),
                          ),
                          SizedBox(height: 32.0),
                          Text(
                            '${item.company}',
                            style: textBold().copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '${item.name}',
                            style: textBold().copyWith(fontSize: 18.0),
                          ),
                          SizedBox(height: 16.0),
                          _textRow(
                            title: 'Address:',
                            value:
                                item.address?.replaceAllMapped(
                                  RegExp(r'<[^>]*>|&[^;]+;'),
                                  (match) => '',
                                ) ??
                                'N/A',
                          ),
                          _textRow(
                            title: 'Company Name:',
                            value: '${item.phone}',
                          ),
                          _textRow(title: 'Email:', value: '${item.email}'),
                          SizedBox(height: 24.0),
                          Text(
                            'Employee Details',
                            style: textBold().copyWith(
                              fontSize: 18.0,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          Divider(),
                          _textRow(title: 'Name:', value: data.fullName),
                          Row(
                            children: [
                              Text(
                                'Payment Status',
                                style: textMeduim().copyWith(
                                  color: AppColors.darkGrey,
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorStatusPayment.withOpacity(0.2),
                                ),
                                child: Text(
                                  data.paymentStatus!,
                                  style: TextStyle(
                                    color: colorStatusPayment,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Text(
                                'Status',
                                style: textMeduim().copyWith(
                                  color: AppColors.darkGrey,
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: colorStatus.withOpacity(0.2),
                                ),
                                child: Text(
                                  data.status!,
                                  style: TextStyle(
                                    color: colorStatus,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Card(
            color: AppColors.bgColorLight,
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Detail Report',
                    style: textBold().copyWith(
                      fontSize: 18.0,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Date: ${data.date}', style: textdefualt()),
                  SizedBox(height: 16.0),
                  Table(
                    border: TableBorder.all(color: AppColors.darkGrey),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(160),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          _buildTableCell('Basic Salary', style: textdefualt()),
                          _buildTableCell(data.basicSalary ?? "-", textAlign: TextAlign.right),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell('Overtime', style: textdefualt()),
                          _buildTableCell(data.overtime ?? "-", textAlign: TextAlign.right),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell(
                            'Cash advanced',
                            style: textdefualt(),
                          ),
                          _buildTableCell(data.cashAdvanced ?? "-", textAlign: TextAlign.right),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell('Tax Payment', style: textdefualt()),
                          _buildTableCell(data.taxPayment ?? "-", textAlign: TextAlign.right),
                        ],
                      ),

                      TableRow(
                        children: [
                          _buildTableCell('Net Salary', style: textdefualt()),
                          _buildTableCell('${data.netSalary ?? "-"}', textAlign: TextAlign.right),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell('Net Pay', style: textdefualt()),
                          _buildTableCell('${data.netPay ?? "-"}', textAlign: TextAlign.right),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell('Gross salary', style: textdefualt()),
                          _buildTableCell(data.grossSalary ?? "-", textAlign: TextAlign.right),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell(
                            'Total Gross salary',
                            style: textdefualt(),
                          ),
                          _buildTableCell(data.totalGrossSalary ?? "-", textAlign: TextAlign.right),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: AppColors.primaryDark),
                        children: [
                          _buildTableCell(
                            'Total Paid',
                            style: textdefualt().copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          _buildTableCell(
                            '${data.totalPaid ?? "-"}',
                            style: textdefualt().copyWith(
                              color: AppColors.textLight,
                            ),
                            textAlign: TextAlign.right, 
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textRow({required String title, String? value, Widget? widget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textMeduim().copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 16.0),
          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child:
                  widget ??
                  Text(
                    value!,
                    style: textMeduim().copyWith(fontWeight: FontWeight.w500),
                  ),
            ),
          ),
        ],
      ),
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
