import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  var products = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var isLoading = false.obs;
  var error = "".obs;

  final ProductService _service = ProductService();
  final storage = GetStorage();

  // Filters
  var selectedCategory = "All".obs;
  var searchQuery = "".obs;

  // Favorites
  var favorites = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites(); // ✅ load from storage
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      error("");
      final result = await _service.getAllProducts();
      products.assignAll(result);
      applyFilters();
      log("Fetched products: ${products.length}");
    } catch (e) {
      error(e.toString());
      log("Error fetching products: $e");
    } finally {
      isLoading(false);
    }
  }

  void applyFilters() {
    List<ProductModel> list = products;

    if (selectedCategory.value != "All") {
      list = list
          .where((p) => p.category?.name == selectedCategory.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredProducts.assignAll(list);
  }

  void filterByCategory(String categoryName) {
    selectedCategory.value = categoryName;
    applyFilters();
  }

  void search(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  /// ✅ Favorites Handling
  void toggleFavorite(int productId) {
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    _saveFavorites(); // save after change
  }

  bool isFavorite(int productId) => favorites.contains(productId);

  void _saveFavorites() {
    storage.write("favorites", favorites.toList());
  }

  void _loadFavorites() {
    final saved = storage.read<List>("favorites") ?? [];
    favorites.addAll(saved.cast<int>());
  }
}
