import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_url.dart';
import 'time_leave_model.dart';

class TimeLeaveService {
  Future<List<TimeLeaveModel>> fetchTimeLeaveData(String? empId) async {
    final response = await http.get(
      Uri.parse('${AppUrl.getApplyLeave}?employee_id=$empId'),
      headers: {'api-key': AppUrl.apiKey},
    );

    final data = json.decode(response.body);
    try {
      if (response.statusCode == 200) {
        if (data['status'] == true) {
          if (data['data'] is List) {
            return (data['data'] as List)
                .map((item) => TimeLeaveModel.fromJson(item))
                .toList();
          } else {
            throw Exception('No time leave data available.');
          }
        } else {
          throw Exception(
            data['message'] ?? 'Failed to fetch time leave data.',
          );
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Error parsing time leave data: $e');
    }
  }

  Future<bool> addTimeLeaveData(AddLeaveModel data) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.postApplyLeave),
        headers: {'api-key': AppUrl.apiKey},
        body: data.toJson(),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          return true;
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to add time leave data.',
          );
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Error adding time leave data: $e');
    }
  }

  Future<List<LeaveType>> getLeaveType(String empId) async {
    final response = await http.get(
      Uri.parse('${AppUrl.getLeaveType}?employee_id=$empId'),
      headers: {'api-key': AppUrl.apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => LeaveType.fromJson(e)).toList();
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }
}
