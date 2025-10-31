import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_url.dart';
import 'report_model.dart';

class ReportService {
  Future<SalaryResponse> getReport(String empId) async {
    try {
      final response = await http
          .get(
            Uri.parse(AppUrl.getSalary).replace(
              queryParameters: {"api-key": AppUrl.apiKey, "employee_id": empId},
            ),
          )
          .timeout(Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return SalaryResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Failed to load salary report');
      }
    } on TimeoutException {
      throw TimeoutException('The connection has timed out.');
    } on SocketException {
      throw SocketException('No Internet connection');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
