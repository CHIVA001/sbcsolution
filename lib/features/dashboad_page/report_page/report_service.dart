import 'dart:convert';
import 'package:cyspharama_app/core/constants/app_url.dart';
import 'package:cyspharama_app/features/dashboad_page/report_page/report_model.dart';
import 'package:http/http.dart' as http;

class ReportService {
  Future<SalaryResponse> getReport(String empId) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrl.getSalary).replace(
          queryParameters: {"api-key": AppUrl.apiKey, "employee_id": empId},
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return SalaryResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Failed to load salary report');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
