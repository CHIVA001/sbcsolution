import 'dart:convert';
import 'dart:developer';
import 'package:cyspharama_app/core/constants/app_url.dart';
import 'package:cyspharama_app/features/dashboad_page/day_off_page/day_off_model.dart';
import 'package:http/http.dart' as http;

class DayOffService {
  Future<DayOffResponse> getDayOffList(String empId) async {
    final uri = Uri.parse(AppUrl.getDayOff).replace(
      queryParameters: {"api-key": AppUrl.apiKey, "employee_id": empId},
    );
    final response = await http.get(uri);
    log('status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DayOffResponse.fromJson(data);
    } else {
      throw Exception('Failed to load data (status ${response.statusCode})');
    }
  }

  Future<DayOffResponse> addDayOff(Map<String, dynamic> data) async {
    final uri = Uri.parse(AppUrl.addDayOff);
    final response = await http.post(
      uri,
      headers: {'api-key': AppUrl.apiKey},
      body: data,
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return DayOffResponse.fromJson(responseBody);
    } else {
      throw Exception(responseBody['message'] ?? 'Failed to add day off.');
    }
  }
}
