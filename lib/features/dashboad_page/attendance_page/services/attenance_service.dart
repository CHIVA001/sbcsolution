import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_url.dart';
import '../models/attenace_model.dart';

class AttendanceService {
  Future<bool> isChekinOut(
    CheckInOutRequest request,
    AttendanceData attendance,
  ) async {
    final response = await http.post(
      Uri.parse(AppUrl.postChekinOut),
      headers: {'api-key': AppUrl.apiKey},
      body: request.toJson(),
    );
    final data = json.decode(response.body);
    log('Status: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 200) {
      if (data['status'] == true) {
        return true;
      } else {
        throw Exception(data['message'] ?? 'Check-in/out failed.');
      }
    } else {
      throw Exception(
        'Failed to check in/out. Status code: ${response.statusCode}',
      );
    }
  }
  //

  Future<CurrentShift> getCurrentShift(String empId, String userId) async {
    final response = await http.post(
      Uri.parse(AppUrl.getShift),
      headers: {'api-key': AppUrl.apiKey},
      body: jsonEncode({'emp_id': empId, 'user_id': empId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true && data['data']['current_shift'] != null) {
        return CurrentShift.fromJson(data['data']['current_shift']);
      } else {
        throw Exception(data['message'] ?? 'No current shift data available.');
      }
    } else {
      throw Exception(
        'Failed to fetch current shift. Status code: ${response.statusCode}',
      );
    }
  }

  Future<AttendanceData> checkinOut({
    required String type,
    required String empId,
    required String userId,
    int? shiftId,
  }) async {
    final response = await http.post(
      Uri.parse(AppUrl.postChekinOut),
      headers: {'api-key': AppUrl.apiKey},
      body: {
        'type': type,
        'emp_id': empId,
        'user_id': userId,
        'shift_id': shiftId,
      },
    );
    final data = json.decode(response.body);
    log(
      'Get Attendance Status: ${response.statusCode}, body: ${response.body}',
    );

    if (response.statusCode == 200) {
      if (data['status'] == true) {
        if (data['data'] is Map<String, dynamic>) {
          return AttendanceData.fromJson(data['data']);
        } else {
          throw Exception('No attendance data available for today.');
        }
      } else {
        throw Exception(data['message'] ?? 'Failed to get attendance status.');
      }
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }
  //

  Future<Map<String, dynamic>> checkIn(
    String userId,
    String empId, {
    String? latitute,
    String? longitute,
    String? qrCode,
  }) async {
    final response = await http.post(
      Uri.parse(AppUrl.postChekinOut),
      headers: {'api-key': AppUrl.apiKey},
      body: {
        'type': '1',
        'user_id': userId,
        'emp_id': empId,
        "latitute": latitute,
        "longitute": longitute,
        "qr_code": qrCode,
      },
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> checkOut(
    String userId,
    String empId,
    String shiftId,
    String? latitute,
    String? longitute,
    String? qrCode,
  ) async {
    final response = await http.post(
      Uri.parse(AppUrl.postChekinOut),
      headers: {'api-key': AppUrl.apiKey},
      body: {
        'type': '2',
        'user_id': userId,
        'emp_id': empId,
        'shift_id': shiftId,
        "latitute": latitute,
        "longitute": longitute,
        "qr_code": qrCode,
      },
    );
    return json.decode(response.body);
  }

  //

  // get check in out list
  Future<List<CheckInOutModel>> getCheckInOutList(String employeeId) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              "${AppUrl.getAttendance}?api-key=${AppUrl.apiKey}&employee_id=$employeeId",
            ),
          )
          .timeout(const Duration(seconds: 10));
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == true) {
          return (data['data'] as List)
              .map((item) => CheckInOutModel.fromJson(item))
              .toList();
        } else {
          throw Exception('Get Attendance Failed: ${data['message']}');
        }
      }
      return [];
    } on TimeoutException {
      throw TimeoutException('The connection has timed out.');
    } on SocketException {
      throw SocketException('No Internet connection');
    } catch (e) {
      throw Exception('Get Attendance Failed');
    }
  }
}
