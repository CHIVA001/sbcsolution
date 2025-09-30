import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weone_shop/constants/app_url.dart';
import '../models/brand_model.dart';

class BrandService {
  Future<List<BrandModel>> getBrands() async {
    final response = await http.get(
      Uri.parse(AppUrl.getBrand),
      headers: {'api-key': AppUrl.apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BrandModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load brands');
    }
  }
}
