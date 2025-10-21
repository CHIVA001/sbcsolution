import 'dart:convert';
import 'dart:developer';
import '/core/constants/app_url.dart';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';

class CategoryService {
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final url = Uri.parse(AppUrl.getCategory);

      final response = await http.get(url, headers: {'api-key': AppUrl.apiKey});

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body is Map && body['data'] != null) {
          final List list = body['data'];
          return list.map((e) => CategoryModel.fromJson(e)).toList();
        }

        if (body is List) {
          return body.map((e) => CategoryModel.fromJson(e)).toList();
        }

        throw Exception("Invalid JSON format");
      } else {
        log('Error response: ${response.body}');
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e, stack) {
      log('Error fetching categories: $e');
      log(stack.toString());
      return [];
    }
  }
}
