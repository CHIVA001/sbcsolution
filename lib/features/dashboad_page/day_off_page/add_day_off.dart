import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/dashboad_page/day_off_page/day_off_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/day_off_page/day_off_model.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:cyspharama_app/widgets/build_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddDayOff extends StatefulWidget {
  const AddDayOff({super.key});

  @override
  State<AddDayOff> createState() => _AddDayOffState();
}

class _AddDayOffState extends State<AddDayOff> {
  DateTime? _selectedDate;
  final _descriptionCtr = TextEditingController();
  final _noteCtr = TextEditingController();
  final _dateCtr = TextEditingController();
  final key = GlobalKey<FormState>();
  final _controller = Get.find<DayOffController>();

  @override
  void dispose() {
    _descriptionCtr.dispose();
    _noteCtr.dispose();
    _dateCtr.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateCtr.text = DateFormat('EEE, dd MMM yyyy').format(picked);
      });
    }
  }

  void _submitForm() {
    if (key.currentState!.validate()) {
      final String formattedDate = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(_selectedDate!);
      final newDayOff = DayOffData(
        dayOff: formattedDate,
        description: _descriptionCtr.text,
        note: _noteCtr.text,
        createdBy: _controller.userId,
        employeeId: _controller.empId,
        biller: '3',
      );

      _controller.addDayOff(newDayOff);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Add Day Off'),
      body: Form(
        key: key,
        child: ListView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            BuildCard(
              margin: EdgeInsets.all(24.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose a day off',
                      style: textBold().copyWith(fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      readOnly: true,
                      onTap: _pickDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      controller: _dateCtr,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Select a date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.darkGrey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.darkGrey,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BuildCard(
              margin: EdgeInsets.all(24.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: textBold().copyWith(fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionCtr,
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
                        hintText: 'Enter Description for your day off...',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 70),
                          child: Icon(Icons.edit_note_outlined, size: 26.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ),
            BuildCard(
              margin: EdgeInsets.all(24.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note (Optional)',
                      style: textBold().copyWith(fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _noteCtr,
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
                        hintText: 'Add a brief note...',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 70),
                          child: Icon(Icons.note_alt_outlined, size: 26.0),
                        ),
                      ),
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.0),
            Container(
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _submitForm,
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
            ),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}
