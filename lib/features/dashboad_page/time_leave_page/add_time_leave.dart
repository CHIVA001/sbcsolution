import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_style.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/build_app_bar.dart';
import 'time_leave_controller.dart';
import 'time_leave_model.dart';

class AddTimeLeave extends StatefulWidget {
  const AddTimeLeave({super.key});

  @override
  State<AddTimeLeave> createState() => _AddTimeLeaveState();
}

class _AddTimeLeaveState extends State<AddTimeLeave> {
  final controller = Get.find<TimeLeaveController>();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  final List<String> timeShifts = ['Morning', 'Afternoon', 'Full'];
  String? selectedTimeShift;
  final Rx<String?> selectedLeaveTypeId = Rx<String?>(null);
  final _reasonController = TextEditingController();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select start date',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        if (selectedEndDate.isBefore(picked)) {
          selectedEndDate = picked;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate.isBefore(selectedStartDate)
          ? selectedStartDate
          : selectedEndDate,
      firstDate: selectedStartDate,
      lastDate: selectedStartDate.add(const Duration(days: 365)),
      helpText: 'Select end date',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  int _calculateLeaveDays() {
    return selectedEndDate.difference(selectedStartDate).inDays + 1;
  }

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Request Leave'),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildLeaveDuration(3),
              //
              SizedBox(height: 24.0),
              _buildLeaveDetail(),
              SizedBox(height: 24.0),
              _buildSubmitButton(
                onPressed: () async {
                  final employeeId = await StorageService().readData('emp_id');

                  if (employeeId == null) {
                    return;
                  }
                  if (key.currentState!.validate()) {
                    await controller.addTimeLeave(
                      AddLeaveModel(
                        employeeId: int.parse(employeeId),
                        startDate: selectedStartDate,
                        endDate: selectedEndDate,
                        leaveType: int.parse(selectedLeaveTypeId.value ?? ''),
                        timeshift: selectedTimeShift ?? '',
                        reason: _reasonController.text,
                        createdBy: 1,
                        biller: 3,
                        note: '',
                      ),
                    );
                    log('leave type: ${selectedLeaveTypeId.value}');
                  }
                },
              ),

              SizedBox(height: 60.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveDetail() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryLight, width: 0.5),
        color: AppColors.primaryLighter.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Form(
        key: key,
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Icon(Icons.description),
              title: Text(
                'Leave Details',
                style: textBold().copyWith(fontSize: 18.0),
              ),
            ),
            _column(
              title: 'Time Shift',
              widget: TimeShiftDropdown(
                timeShifts: timeShifts,
                selectedValue: selectedTimeShift,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimeShift = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 16.0),
            _column(
              title: 'Leave Type',
              widget: Obx(() {
                if (controller.isLoading.value &&
                    controller.leaveType.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DropdownSearch<String>(
                  items: (String filter, LoadProps? loadProps) async {
                    // Show only the names
                    return controller.leaveType
                        .where(
                          (leaveType) =>
                              filter.isEmpty ||
                              (leaveType.name ?? '').toLowerCase().contains(
                                filter.toLowerCase(),
                              ),
                        )
                        .map((leaveType) => leaveType.name ?? '')
                        .toList();
                  },

                  selectedItem: selectedLeaveTypeId.value == null
                      ? null
                      : controller.leaveType
                            .firstWhereOrNull(
                              (e) =>
                                  e.id.toString() == selectedLeaveTypeId.value,
                            )
                            ?.name,

                  dropdownBuilder: (context, selectedItem) {
                    return Text(
                      selectedItem ?? 'Select Leave Type',
                      style: textdefualt().copyWith(
                        color: selectedItem == null
                            ? AppColors.darkGrey
                            : AppColors.textPrimary,
                      ),
                    );
                  },

                  onChanged: (String? value) {
                    if (value != null) {
                      // Find the matching leave type by name and save its ID
                      final leave = controller.leaveType.firstWhereOrNull(
                        (e) => e.name == value,
                      );
                      selectedLeaveTypeId.value = leave?.id.toString();
                    }
                  },

                  validator: (value) {
                    if (value == null) {
                      return "Please select a leave type";
                    }
                    return null;
                  },
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  suffixProps: DropdownSuffixProps(
                    clearButtonProps: ClearButtonProps(isVisible: true),
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.work_history,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    constraints: const BoxConstraints(maxHeight: 200.0),
                  ),
                );
              }),
            ),

            SizedBox(height: 16.0),
            _column(
              title: 'Reason',
              widget: TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  hintText: 'Enter reason for leave...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 70),
                    child: Icon(Icons.edit_note_outlined, size: 26.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (value) {},
                maxLines: 4,
                keyboardType: TextInputType.multiline,
              ),
            ),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveDuration(int duration) {
    final totalDays = _calculateLeaveDays();
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLighter.withOpacity(0.05),
        border: Border.all(color: AppColors.primaryLight, width: 0.5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Icon(Icons.date_range),
            title: Text(
              'Leave Duration',
              style: textBold().copyWith(fontSize: 18.0),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => _selectStartDate(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      tileColor: AppColors.lightGrey,
                      leading: Icon(
                        Icons.event_outlined,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'Start Date',
                        style: textMeduim().copyWith(color: AppColors.darkGrey),
                      ),
                      subtitle: Text(
                        DateFormat('dd-MMM-yyy').format(selectedStartDate),
                        style: textBold(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => _selectEndDate(context),
                      tileColor: AppColors.lightGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      leading: Icon(
                        Icons.event_available_outlined,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'End Date',
                        style: textMeduim().copyWith(color: AppColors.darkGrey),
                      ),
                      subtitle: Text(
                        DateFormat('dd-MMM-yyy').format(selectedEndDate),
                        style: textBold(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            tileColor: AppColors.lightGrey,
            leading: Icon(Icons.access_time, color: AppColors.primaryColor),
            title: Text(
              'Total Days',
              style: textMeduim().copyWith(color: AppColors.darkGrey),
            ),
            subtitle: Text(
              '$totalDays Day${totalDays != 1 ? 's' : ''}',
              style: textBold(),
            ),
          ),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget _column({required String title, required Widget widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textMeduim().copyWith(color: AppColors.darkGrey)),
        SizedBox(height: 8),
        widget,
      ],
    );
  }

  Widget _buildSubmitButton({required void Function()? onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: onPressed,
        label: Text(
          'Submit',
          style: textdefualt().copyWith(
            color: AppColors.textLight,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: Icon(Icons.send, size: 24),
      ),
    );
  }
}

class TimeShiftDropdown extends StatelessWidget {
  final ValueChanged<String?>? onChanged;
  final String? selectedValue;
  final List<String> timeShifts;

  const TimeShiftDropdown({
    super.key,
    this.onChanged,
    this.selectedValue,
    required this.timeShifts,
  });

  @override
  Widget build(BuildContext context) {
    // final List<String> timeShifts = ['Morning', 'Afternoon', 'Full'];
    return DropdownSearch<String>(
      items: (filter, loadProps) {
        return Future.value(
          timeShifts
              .where(
                (shift) =>
                    filter.isNotEmpty ||
                    shift.toLowerCase().contains(filter.toLowerCase()),
              )
              .toList(),
        );
      },
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(isVisible: true),
      ),
      validator: (value) {
        if (value == null) {
          return "Please select a time shift";
        }
        return null;
      },
      autoValidateMode: AutovalidateMode.onUserInteraction,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
          prefixIcon: Icon(Icons.access_time, color: AppColors.primaryColor),
        ),
      ),

      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        constraints: BoxConstraints(maxHeight: 200.0),
      ),
      selectedItem: selectedValue,

      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem ?? 'Select Time Shift',
          style: textdefualt().copyWith(
            color: selectedItem == null
                ? AppColors.darkGrey
                : AppColors.textPrimary,
          ),
        );
      },
      onChanged: onChanged,
    );
  }
}
