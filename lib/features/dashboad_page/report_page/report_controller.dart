import 'package:cyspharama_app/features/dashboad_page/report_page/report_model.dart';
import 'package:cyspharama_app/features/dashboad_page/report_page/report_service.dart';
import 'package:cyspharama_app/services/storage_service.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  final _service = ReportService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isError = false.obs;
  final errorNetwork = false.obs;

  final reportSalary = <SalaryData>[].obs;
  String empId = '';

  @override
  void onInit() async {
    final getEmpId = await StorageService().readData('emp_id');
    empId = getEmpId!;
    await getReport();
    super.onInit();
  }

  Future<void> getReport() async {
    isLoading.value = true;
    errorMessage.value = '';
    errorNetwork.value = false;
    isError(false);

    try {
      final response = await _service.getReport(empId);
      if (response.status) {
        reportSalary.assignAll(response.data);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      errorNetwork.value = true;
      isError(true);
    } finally {
      isLoading.value = false;
    }
  }
}
