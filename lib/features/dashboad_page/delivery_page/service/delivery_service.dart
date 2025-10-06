import 'dart:convert';
import 'dart:developer';
import 'package:cyspharama_app/core/constants/app_url.dart';
import 'package:http/http.dart' as http;
import '../model/delivery_model.dart';

class DeliveryService {
  Future<DeliveryModel?> getDispatchFromQr(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'api-key': AppUrl.apiKey},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DeliveryModel.fromJson(data);
      } else {
        log("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Exception: $e");
      return null;
    }
  }

  Future<bool> updateDeliveryStatus(int dispatchId, String status) async {
    final Uri uri = Uri.parse(AppUrl.updateDispatch);

    final body = {"dispatch_id": dispatchId, "deliveries_status": status};

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json", 'api-key': AppUrl.apiKey},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        log("Bad Request: ${response.body}");
        return false;
      }
    } catch (e) {
      log("Exception in updateDeliveryStatus: $e");
      return false;
    }
  }
}
