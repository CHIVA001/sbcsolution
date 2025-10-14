import 'dart:io';
import 'package:get/get.dart';
import '../../../services/storage_service.dart';
import 'day_off_service.dart';
import 'day_off_model.dart';

class DayOffController extends GetxController {
  final DayOffService _service = DayOffService();

  var isLoading = false.obs;
  var errorNetwork = false.obs;
  var message = ''.obs;

  var dayOffList = <DayOffData>[].obs;
  var hasError = false.obs;
  String empId = "";
  String userId = "";

  @override
  void onInit() async {
    super.onInit();
    final getEmpId = await StorageService().readData('emp_id');
    final getUserId = await StorageService().readData('user_id');
    empId = getEmpId!;
    userId = getUserId!;
    fetchDayOff();
  }

  Future<void> fetchDayOff() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorNetwork(false);

      final response = await _service.getDayOffList(empId);

      if (response.status) {
        dayOffList.assignAll(response.data);
        message.value = response.message ?? "";
      } else {
        dayOffList.clear();
        message.value = response.message ?? "No data found";
      }
    }on SocketException {
      await Future.delayed(Duration(milliseconds: 500));
      errorNetwork(true);
    } catch (e) {
      hasError.value = true;
      message.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDayOff(DayOffData data) async {
    try {
      isLoading.value = true;
      final postData = {
        'date': data.dayOff ?? '',
        'biller': '3',
        'employee_id': data.employeeId ?? empId,
        'day_off': data.dayOff ?? '',
        'description': data.description ?? '',
        'note': data.note ?? '',
        'created_by': data.createdBy ?? '1',
      };

      final response = await _service.addDayOff(postData);

      if (response.status) {
        Get.back();
        Get.snackbar(
          'Success',
          'Day Off added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        message.value = response.message ?? "No data found";
      }
    } catch (e) {
      message.value = e.toString();
    } finally {
      isLoading.value = false;
      fetchDayOff();
    }
  }
}
