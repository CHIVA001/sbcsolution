import 'dart:developer';
import 'dart:io';
import 'package:cyspharama_app/core/constants/app_message.dart';
import 'package:cyspharama_app/features/dashboad_page/time_leave_page/time_leave_model.dart';
import 'package:cyspharama_app/features/dashboad_page/time_leave_page/time_leave_service.dart';
import 'package:cyspharama_app/services/storage_service.dart';
import 'package:get/get.dart';

class TimeLeaveController extends GetxController {
  final isLoading = true.obs;
  final isSubmitting = false.obs;
  final errorMessage = false.obs;
  final errorNetwork = false.obs;
  final timeLeaveList = <TimeLeaveModel>[].obs;
  final leaveType = <LeaveType>[].obs;
  final StorageService _storageService = StorageService();
  final _service = TimeLeaveService();
  String? empId;

  @override
  void onInit() async {
    super.onInit();
    final getEmpId = await _storageService.readData('emp_id');
    empId = getEmpId;
    getTimeLeave();
    getLeaveType();
  }

  Future<void> getTimeLeave() async {
    try {
      isLoading(true);
      errorMessage(false);
      errorNetwork(false);
      final response = await _service.fetchTimeLeaveData(empId);
      timeLeaveList
        ..assignAll(response)
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
    } on SocketException {
      errorNetwork(true);
    } catch (e) {
      errorMessage(true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTimeLeave(AddLeaveModel timeLeaveModel) async {
    try {
      isSubmitting(true);
      final success = await _service.addTimeLeaveData(timeLeaveModel);
      log('success: $success');
      if (success) {
        Get.back();
        showCustomSnackbar(
          title: 'Success',
          message: 'Leave request submitted wait for approval...',
          type: SnackbarType.success,
        );
        await getTimeLeave();
      } else {
        // Get.snackbar('Error', 'Failed to submit leave request.');
      }
    } on SocketException {
      Get.snackbar('Error', 'No internet connection.');
    } catch (e) {
      Get.snackbar('Error ', e.toString());
    } finally {
      isSubmitting(false);
    }
  }
  // +++++++++++++++++++++++++++++++++++++++++++++

  Future<void> getLeaveType() async {
    try {
      isLoading(true);
      final response = await _service.getLeaveType('32');
      leaveType.assignAll(response);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      log('error get Leave Type: $e');
    } finally {
      isLoading(false);
    }
  }
}
