import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_style.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/storage_service.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../models/shift_model.dart';
import '../services/attenance_service.dart';
import '../services/shift_service.dart';

class ShiftController extends GetxController {
  final _companyCtr = Get.find<AuthController>();
  var shift = Rxn<ShiftModel>();
  final attendanceService = AttendanceService();
  final shiftService = ShiftService();

  var isLoading = false.obs;

  String userId = '';
  String empId = '';
  String shiftId = '';
  String qrCode = '';

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    userId = await StorageService().getUserId();
    empId = await StorageService().getEmpId();
    if (userId.isEmpty || empId.isEmpty) {
      log('User or Emp ID missing, waiting for login...');
      return;
    }

    shiftId = await StorageService().readData('shift_id') ?? '';
    await _companyCtr.getCompanies();
    qrCode = _companyCtr.companies.isNotEmpty
        ? _companyCtr.companies.first.qrCode!
        : '';
    if (shiftId.isEmpty) {
      await getShiftId();
    }
    getShiftId();
  }

  ///  Unified Attendance Handler
  Future<void> handleAttendance({
    required String latitute,
    required String longitute,
    bool fromQr = false,
  }) async {
    if (isLoading.value) return;
    isLoading(true);

    try {
      await getShiftId();
      final userId = await StorageService().getUserId();
      final empId = await StorageService().getEmpId();
      if (shift.value == null || shiftId.isEmpty) {
        ///  CHECK-IN
        final response = await attendanceService.checkIn(
          userId,
          empId,
          latitute: latitute,
          longitute: longitute,
          qrCode: fromQr ? qrCode : '',
        );
        log('Repone check in :$response');
        log(
          'userId: $userId, empId: $empId, latitute: $latitute, longitute: $longitute, qrCode: ${fromQr ? qrCode : ''}',
        );
        if (response['status'] == true || response['shift_status'] == 1) {
          shift.value = ShiftModel.fromJson(response['data']['current_shift']);
          shiftId = response['data']['shift_id'].toString();
          await StorageService().writeData('shift_id', shiftId);

          Get.offAndToNamed(AppRoutes.attendance);
          Fluttertoast.showToast(
            msg: "You're checked in.",
            timeInSecForIosWeb: 3,
            backgroundColor: AppColors.successColor,
          );
        } else {
          Get.dialog(
            AlertDialog(
              title: const Text('Error'),
              content: Text(
                response["message"] + '\nPlease try again.' ??
                    "Check-in failed",
                style: textMeduim(),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        ///  CHECK-OUT
        final response = await attendanceService.checkOut(
          userId,
          empId,
          shiftId,
          latitute,
          longitute,
          fromQr ? qrCode : '',
        );
        log('Repone out :$response');
        if (response['status'] == true) {
          shift.value = ShiftModel.fromJson(response['data']);
          shiftId = '';
          await StorageService().deleteData('shift_id');

          Get.offAndToNamed(AppRoutes.attendance);
          Fluttertoast.showToast(
            msg: "You're checked Out.",
            timeInSecForIosWeb: 3,
            backgroundColor: AppColors.successColor,
          );
        } else {
          // Get.snackbar("Error", response["message"] ?? "Check-out failed");
          log('Error shiftCtr: ${response["message"] ?? "Check-out failed"} ');
        }
      }
    } catch (e) {
      // Get.snackbar("Error", "Unexpected error: $e");
      log('Error shiftCtr: Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> getShiftId() async {
    try {
      final userId = await StorageService().getUserId();
      final empId = await StorageService().getEmpId();
      if (userId.isEmpty || empId.isEmpty) {
        log('User or Emp ID missing, cannot fetch shift.');
        return;
      }
      final shiftData = await shiftService.getShift(
        userId: userId,
        empId: empId,
      );

      if (shiftData != null) {
        shift.value = shiftData;
        shiftId = shiftData.shiftId.toString();
        await StorageService().writeData('shift_id', shiftId);
      } else {
        shift.value = null;
        shiftId = '';
        await StorageService().deleteData('shift_id');
      }
    } catch (e) {
      // Get.snackbar("Error", "Failed to load shift: $e");
      log('Error shiftCtr: Failed to load shift: $e');
    }
  }
}
