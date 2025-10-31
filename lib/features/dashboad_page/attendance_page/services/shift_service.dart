import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_url.dart';
import '../models/shift_model.dart';

class ShiftService {
  Future<ShiftModel?> getShift({
    required String userId,
    required String empId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.getShift),
        headers: {'api-key': AppUrl.apiKey},
        body: {'user_id': userId, 'emp_id': empId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final currentShiftData = data['data']['current_shift'];

          if (currentShiftData == null ||
              (currentShiftData is List && currentShiftData.isEmpty)) {
            log('No current shift available.');
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
        log('HTTP Error(shift CTR): ${response.statusCode}');
        return null;
      }
    } catch (e, s) {
      log('Error in ShiftService.getShift: $e');
      log('StackTrace: $s');
      return null;
    }
  }
}
