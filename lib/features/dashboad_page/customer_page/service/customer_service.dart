import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_url.dart';
import '../customer_model.dart';

class CustomerFetchResult {
  final List<CustomerModel> customers;
  final int totalCount;

  CustomerFetchResult(this.customers, this.totalCount);
}

class CustomerService {
  Future<CustomerFetchResult> fetchCustomers({
    int start = 0,
    int limit = 20,
  }) async {
    try {
      final url = '${AppUrl.baseUrl}/companies?start=$start&limit=$limit';
      final response = await http.get(
        Uri.parse(url),
        headers: {'api-key': AppUrl.apiKey},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        final int total = jsonResponse['total'] ?? 0;

        final customers = data.map((e) => CustomerModel.fromJson(e)).toList();

        return CustomerFetchResult(customers, total + 1);
      } else {
        throw Exception('Failed to load customers');
      }
    } on SocketException {
      throw SocketException('No Internet connection');
    } catch (e) {
      throw Exception('Error Customer: $e');
    }
  }
}
