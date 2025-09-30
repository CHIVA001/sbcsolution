// import 'dart:developer';

// import 'package:cyspharama_app/core/themes/app_colors.dart';
// import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
// import 'package:cyspharama_app/features/dashboad_page/attendance_page/models/shift_model.dart';
// import 'package:cyspharama_app/features/dashboad_page/attendance_page/services/attenance_service.dart';
// import 'package:cyspharama_app/features/dashboad_page/attendance_page/services/shift_service.dart';
// import 'package:cyspharama_app/routes/app_routes.dart';
// import 'package:cyspharama_app/services/storage_service.dart';
// import 'package:get/get.dart';

// final _companyCtr = Get.find<AuthController>();

// class ShiftController extends GetxController {
//   var shift = Rxn<ShiftModel>();
//   final attendanceService = AttendanceService();
//   final shiftService = ShiftService();

//   var isLoading = false.obs;

//   String userId = '';
//   String empId = '';
//   String shiftId = '';
//   String qrCode = '';

//   @override
//   void onInit() {
//     super.onInit();
//     _initData();
//   }

//   Future<void> _initData() async {
//     userId = await StorageService().readData('user_id') ?? '';
//     empId = await StorageService().readData('emp_id') ?? '';
//     shiftId = await StorageService().readData('shift_id') ?? '';
//     qrCode = _companyCtr.companies.isNotEmpty
//         ? _companyCtr.companies.first.qrCode!
//         : '';

//     log('myQrgggg : $qrCode');
//     // log('data: ${_companyCtr.companies}');

//     if (shiftId.isEmpty) {
//       await getShiftId();
//     }
//   }

//   Future<void> handleTapCheckInOut({
//     String? latitute,
//     String? longitute,
//   }) async {
//     await _handleAttendance(latitute: latitute, longitute: longitute);
//   }

//   Future<void> handleQrScanner({String? latitute, String? longitute}) async {
//     await _handleAttendance(
//       latitute: latitute,
//       longitute: longitute,
//       useQr: true,
//     );
//   }

//   Future<void> _handleAttendance({
//     String? latitute,
//     String? longitute,
//     bool useQr = true,
//     // String? qrCode,
//   }) async {
//     if (isLoading.value) return;
//     isLoading(true);

//     try {
//       if (shift.value == null || shiftId.isEmpty) {
//         // === CHECK-IN ===
//         final response = await attendanceService.checkIn(
//           userId,
//           empId,
//           latitute: latitute,
//           longitute: longitute,
//           qrCode: useQr ? qrCode : '',
//         );

//         if (response['status'] == true || response['shift_status'] == 1) {
//           shift.value = ShiftModel.fromJson(response['data']['current_shift']);
//           shiftId = response['data']['shift_id'].toString();
//           await StorageService().writeData('shift_id', shiftId);
//           log('re n n:${response['data']}');
//           Get.toNamed(AppRoutes.attendance);
//           Get.snackbar(
//             "Success",
//             response["message"],
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.successColor,
//           );
//         } else {
//           Get.snackbar("Error", response["message"] ?? "Check-in failed");
//         }
//       } else {
//         // === CHECK-OUT ===
//         final response = await attendanceService.checkOut(
//           userId,
//           empId,
//           shiftId,
//           latitute,
//           longitute,
//           useQr ? qrCode : '',
//         );

//         if (response['status'] == true) {
//           shift.value = ShiftModel.fromJson(response['data']);
//           shiftId = '';
//           await StorageService().deleteData('shift_id');
//           log('re n n:${response['data']}');
//           Get.toNamed(AppRoutes.attendance);
//           Get.snackbar(
//             "Success",
//             "Checked out successfully!",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.successColor,
//           );
//         } else {
//           Get.snackbar("Error", response["message"] ?? "Check-out failed");
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Unexpected error: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> getShiftId() async {
//     try {
//       final shiftData = await shiftService.getShift(
//         userId: userId,
//         empId: empId,
//       );

//       if (shiftData != null) {
//         shift.value = shiftData;
//         shiftId = shiftData.shiftId.toString();
//         await StorageService().writeData('shift_id', shiftId);
//       } else {
//         shift.value = null;
//         shiftId = '';
//         await StorageService().deleteData('shift_id');
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load shift: $e");
//     }
//   }
// }

import 'dart:developer';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/attendance_page/models/shift_model.dart';
import 'package:cyspharama_app/features/dashboad_page/attendance_page/services/attenance_service.dart';
import 'package:cyspharama_app/features/dashboad_page/attendance_page/services/shift_service.dart';
import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:cyspharama_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

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
    userId = await StorageService().readData('user_id') ?? '';
    empId = await StorageService().readData('emp_id') ?? '';
    shiftId = await StorageService().readData('shift_id') ?? '';
    await _companyCtr.getCompanies();
    qrCode = _companyCtr.companies.isNotEmpty
        ? _companyCtr.companies.first.qrCode!
        : '';
    if (shiftId.isEmpty) {
      await getShiftId();
    }
  }

  /// ✅ Unified Attendance Handler
  Future<void> handleAttendance({
    required String latitute,
    required String longitute,
    bool fromQr = false,
  }) async {
    if (isLoading.value) return;
    isLoading(true);

    try {
      if (shift.value == null || shiftId.isEmpty) {
        /// 🟢 CHECK-IN
        final response = await attendanceService.checkIn(
          userId,
          empId,
          latitute: latitute,
          longitute: longitute,
          qrCode: fromQr ? qrCode : '',
        );
        log('Repone in :$response');
        if (response['status'] == true || response['shift_status'] == 1) {
          shift.value = ShiftModel.fromJson(response['data']['current_shift']);
          shiftId = response['data']['shift_id'].toString();
          await StorageService().writeData('shift_id', shiftId);

          Get.offAndToNamed(AppRoutes.attendance);
          Get.snackbar(
            "Success",
            response["message"] ?? "Checked in successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.successColor,
          );
        } else {
          Fluttertoast.showToast(msg: response["message"]);
          Get.snackbar("Error", response["message"] ?? "Check-in failed");
          Get.defaultDialog(
            title: "Error",
            content: Column(
              children: [
                Text(response["message"]),
                //
              ],
            ),
            cancel: Column(
              children: [
                Divider(),
                TextButton(onPressed: () {}, child: Text('OK')),
              ],
            ),
          );
        }
      } else {
        /// 🔴 CHECK-OUT
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
          Get.snackbar(
            "Success",
            "Checked out successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.successColor,
          );
        } else {
          Get.snackbar("Error", response["message"] ?? "Check-out failed");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getShiftId() async {
    try {
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
      Get.snackbar("Error", "Failed to load shift: $e");
    }
  }
}
