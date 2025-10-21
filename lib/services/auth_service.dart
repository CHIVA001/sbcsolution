import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../core/constants/app_url.dart';
import '../data/models/user_model.dart';

class AuthService {
  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(AppUrl.loginUrl),
      headers: {'api-key': AppUrl.apiKey},
      body: {'user_name': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == true) {
        return UserModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? "Login failed");
      }
    } else {
      final data = json.decode(response.body);
      throw Exception(
        data['message'] ?? "Server error: ${response.statusCode}",
      );
    }
  }

  /// get user profile
  Future<UserModel> getUser(String userId) async {
    final response = await http.get(
      Uri.parse(
        AppUrl.getProfile,
      ).replace(queryParameters: {'user_id': userId}),
      headers: {'api-key': AppUrl.apiKey},
    );
    // log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return UserModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? "Login failed");
      }
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }

  // Future<UserModel> getProfile({required String userId}) async {
  //   final response = await http.post(
  //     Uri.parse(AppUrl.getProfile),
  //     headers: {'api-key': AppUrl.apiKey},
  //     body: {'user_id': userId},
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);

  //     if (data['status'] == true) {
  //       return UserModel.fromJson(data['data']);
  //     } else {
  //       throw Exception(data['message'] ?? "Login failed");
  //     }
  //   } else {
  //     log("Server error: ${response.statusCode}");
  //     throw Exception("Server error: ${response.statusCode}");
  //   }
  // }

  // get comapny
  Future<CompanyModel> getCompany() async {
    final response = await http.get(
      Uri.parse('${AppUrl.getCompanies}?group=biller'),
      headers: {'api-key': AppUrl.apiKey},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CompanyModel.fromJson(data);
    } else {
      throw Exception("Server error(comapny): ${response.statusCode}");
    }
  }
}
