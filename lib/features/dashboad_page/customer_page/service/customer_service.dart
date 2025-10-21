import 'dart:convert';
import 'dart:io';
import 'package:cyspharama_app/core/constants/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../customer_model.dart';

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
}
