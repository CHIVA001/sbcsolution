import 'dart:convert';
import 'dart:developer';
import 'package:cyspharama_app/core/constants/app_url.dart';
import 'package:cyspharama_app/features/dashboad_page/attendance_page/models/shift_model.dart';
import 'package:http/http.dart' as http;

class ShiftService {
  Future<ShiftModel?> getShift({required String userId, required String empId,}) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.getShift),
        headers: {'api-key': AppUrl.apiKey},
        body: {'user_id': userId,
        'emp_id': empId},
      );

      // log('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // log('Response: $data');

        if (data['status'] == true && data['data'] != null) {
          final currentShiftData = data['data']['current_shift'];

          if (currentShiftData is List && currentShiftData.isEmpty) {
            // log('No current shift available.');
            return null;
          }

          if (currentShiftData is Map<String, dynamic>) {
            return ShiftModel.fromJson(currentShiftData);
          } else {
            log(
              'Unexpected data type for current_shift: ${currentShiftData.runtimeType}',
            );
            return null;
          }
        } else {
          log('API status is false or data is missing.');
          return null;
        }
      } else {
        log('HTTP Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }
}
