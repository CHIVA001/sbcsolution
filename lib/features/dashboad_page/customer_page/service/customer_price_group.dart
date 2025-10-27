import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../models/customer_group_model.dart';
import '/core/constants/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/customer_price_group.dart';

class CustomerPriceGroupService {
  Future<List<CustomerPriceGroupModel>> getPriceGroup() async {
    final uri = Uri.parse(AppUrl.getPriceGroups);
    final headers = {'api-key': AppUrl.apiKey};
    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CustomerPriceGroupModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load price groups: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching price groups: $e');
    }
  }

  Future<List<CustomerGroupModel>> getCustomerGroup() async {
    final uri = Uri.parse(AppUrl.getCustomerGroups);
    final headers = {'api-key': AppUrl.apiKey};
    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CustomerGroupModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load price groups: ${response.statusCode}');
      }
    } on TimeoutException {
      throw TimeoutException('The connection has timed out.');
    } on SocketException {
      throw SocketException('No Internet connection');
    } catch (e) {
      throw Exception('Error fetching price groups: $e');
    }
  }
}
