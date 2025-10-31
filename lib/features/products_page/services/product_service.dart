import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_url.dart';
import '../models/product_model.dart';

class ProductService {
  Future<List<ProductModel>> getAllProducts() async {
    int start = 1;
    int limit = 50;
    List<ProductModel> allProducts = [];

    while (true) {
      final uri = Uri.parse(AppUrl.getProduct).replace(
        queryParameters: {
          'include': 'brand,category',
          "limit": "$limit",
          "start": "$start",
        },
      );
      final response = await http.get(uri, headers: {'api-key': AppUrl.apiKey});
      if (response.statusCode != 200) {
        throw Exception("Failed to load products: ${response.body}");
      }
      final body = json.decode(response.body);
      if (body['data'] == null) break;
      final List data = body['data'];
      final List<ProductModel> products = data
          .where((e) => e != null)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      allProducts.addAll(products);
      if (products.length < limit) break;
      start += limit;
    }

    return allProducts;
  }
}
