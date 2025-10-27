import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '/core/constants/app_url.dart';
import '/features/dashboad_page/customer_page/models/add_cusomer_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/customer_model.dart';

class CustomerService {
  Future<Response> fetchAllCustomers({int pageLimit = 10}) async {
    try {
      int start = 1;
      final List<CustomerModel> all = [];
      int total = -1;

      while (true) {
        final uri = Uri.parse(AppUrl.getCustomer).replace(
          queryParameters: {
            'start': start.toString(),
            'limit': pageLimit.toString(),
          },
        );

        final res = await http
            .get(uri, headers: {'api-key': AppUrl.apiKey})
            .timeout(const Duration(seconds: 15));

        if (res.statusCode != 200) {
          return Response(statusCode: res.statusCode, body: res.body);
        }

        final Map<String, dynamic> jsonData = json.decode(res.body);
        final List<dynamic> data = (jsonData['data'] as List<dynamic>?) ?? [];

        final pageItems = data
            .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
            .toList();
        all.addAll(pageItems);

        total = jsonData['total'] is int
            ? jsonData['total']
            : int.tryParse(jsonData['total']?.toString() ?? '') ?? total;

        if (pageItems.length < pageLimit) break;
        if (total >= 0 && all.length >= total) break;

        start += pageLimit;
      }

      return Response(statusCode: 200, body: all);
    } on SocketException {
      return Response(statusCode: 503, body: 'No Internet connection');
    } on FormatException catch (e) {
      return Response(statusCode: 400, body: 'Invalid response format: $e');
    } catch (e) {
      return Response(statusCode: 500, body: e.toString());
    }
  }

  // add Customers
  Future<bool> addCustomer(AddCustomerModel customer) async {
    final uri = Uri.parse(AppUrl.addCustomer);
    final headers = {
      'Content-Type': 'application/json',
      'api-key': AppUrl.apiKey,
    };

    try {
      final body = jsonEncode(customer.toJson());
      final response = await http
          .post(uri, headers: headers, body: body)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true) {
          // log("✅ Customer added successfully: ${jsonResponse['message']}");
          return true;
        } else {
          // log("❌ Failed to add customer: ${jsonResponse['message']}");
          return false;
        }
      } else {
        // log(
        //   "❌ Failed to add customer. Status code: ${response.statusCode}, Body: ${response.body}",
        // );
        return false;
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please check your internet.');
    } on SocketException {
      throw Exception('No internet connection.');
    } catch (e) {
      throw Exception('Error adding customer: $e');
    }
  }
}
