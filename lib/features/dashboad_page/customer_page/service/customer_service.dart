import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_url.dart';
import '../customer_model.dart';

class CustomerService {
  Future<List<CustomerModel>> fetchCustomers({int start = 0, int limit = 20}) async {
    final url = '${AppUrl.baseUrl}/companies?start=$start&limit=$limit';
    final response = await http.get(
      Uri.parse(url),
      headers: {'api-key': AppUrl.apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((e) => CustomerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }
}
