import 'dart:developer';
import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryController extends GetxController {
  /// Observable variables
  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Service instance
  final CategoryService _service = CategoryService();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Fetch all categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.fetchCategories();

      if (result.isEmpty) {
        errorMessage.value = 'No categories found.';
      } else {
        categories.assignAll(result);
      }

      log(' Loaded ${categories.length} categories');
    } catch (e, stack) {
      log(' Error fetching categories: $e', stackTrace: stack);
      errorMessage.value = 'Failed to load categories. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh manually (for pull-to-refresh or retry)
  Future<void> refreshCategories() async {
    await fetchCategories();
  }
}
