import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../constants/app_url.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  var categoryList = <CategoryModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse(AppUrl.getCategories),
        headers: {'api-key': AppUrl.apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        categoryList.value =
            data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        // handle error
      }
    } catch (e) {
      // handle error
    } finally {
      isLoading(false);
    }
  }
}
