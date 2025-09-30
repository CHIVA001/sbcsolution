import 'dart:convert';
import 'package:cyspharama_app/core/constants/app_url.dart';
import 'package:cyspharama_app/features/dashboad_page/product_page/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final Map<String, String> headers = {'api-key': AppUrl.apiKey};

  Future<ProductResponse> fetchProducts({
    required int page,
    int limit = 10,
  }) async {
    final url = '${AppUrl.getProduct}?page=$page&limit=$limit';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load products: ${response.statusCode}");
    }

    final decoded = json.decode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }
    return ProductResponse.fromJson(decoded);
  }
}
