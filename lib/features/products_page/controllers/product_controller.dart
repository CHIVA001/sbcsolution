import 'dart:developer';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

enum ViewMode { grid, list }

class ProductsController extends GetxController {
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;

  final isLoading = false.obs;
  var qty = 1.obs;

  var viewMode = ViewMode.grid.obs;
  var selectedCategoryId = Rxn<String>(); 

  final ProductService service = ProductService();

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      isLoading.value = true;
      final fetchedProducts = await service.getAllProducts();
      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(fetchedProducts);
      log('Fetched ${products.length} products');
    } catch (e, stack) {
      log('Error fetching products: $e', stackTrace: stack);
      Get.snackbar('Error', 'Failed to load products. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  ///  Filter products by category
  void filterByCategory(String? categoryId) {
    selectedCategoryId.value = categoryId;

    if (categoryId == null) {
      filteredProducts.assignAll(products);
    } else {
     filteredProducts.assignAll(
  products.where((p) => p.category?.id.toString() == categoryId.toString()).toList(),
);

    }
  }

  /// Change view mode
  void toggleViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  void decreament() {
    if (qty > 1) qty--;
  }

  void inCreament() {
    qty++;
  }
}
