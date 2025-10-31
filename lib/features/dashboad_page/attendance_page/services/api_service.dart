// This service handles all API interactions.

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_url.dart';

class ApiService {
  // Fetches the user's profile.
  Future<Response> getProfile(String userId) async {
    final response = await http.post(
      Uri.parse(AppUrl.getProfile),
      headers: {'api-key': AppUrl.apiKey},
      body: {'user_id': userId},
    );
    return Response(
      statusCode: response.statusCode,
      bodyString: response.body,
      body: jsonDecode(response.body),
    );
  }

  // Fetches the current shift details for the user.
  Future<Response> getCurrentShift(String userId) async {
    final response = await http.post(
      Uri.parse(AppUrl.getShift),
      headers: {'api-key': AppUrl.apiKey},
      body: {'user_id': userId},
    );
    return Response(
      statusCode: response.statusCode,
      bodyString: response.body,
      body: jsonDecode(response.body),
    );
  }

  // Handles both check-in (type=1) and check-out (type=2) requests.
  Future<Response> checkinOut({
    required String type,
    required String empId,
    required String userId,
    String? shiftId,
    String? qrCode,
  }) async {
    final Map<String, dynamic> body = {
      'type': type,
      'emp_id': empId,
      'user_id': userId,
      'shift_id': shiftId,
    };

    if (qrCode != null) {
      body['qr_code'] = qrCode;
    }

    final response = await http.post(
      Uri.parse(AppUrl.postChekinOut),
      headers: {'api-key': AppUrl.apiKey},
      body: body,
    );

    return Response(
      statusCode: response.statusCode,
      bodyString: response.body,
      body: jsonDecode(response.body),
    );
  }
}
