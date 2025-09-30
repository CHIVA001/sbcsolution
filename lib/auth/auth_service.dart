import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:weone_shop/constants/app_url.dart';
import 'user_model.dart';

class AuthService {
  Future<UserModel> login(String username, String password) async {
    final url = Uri.parse(AppUrl.login);
    final response = await http.post(
      url,
      headers: {'api-key': AppUrl.apiKey},
      body: {"user_name": username, "password": password},
    );

    log('Stauts: ${response.statusCode}');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body["status"] == true) {
        return UserModel.fromJson(body["data"]);
      } else {
        throw Exception(body["message"] ?? "Login failed");
      }
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }
}
