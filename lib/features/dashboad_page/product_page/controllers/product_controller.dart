import 'package:get/get.dart';
import 'package:cyspharama_app/features/dashboad_page/product_page/models/product_model.dart';
import 'package:cyspharama_app/features/dashboad_page/product_page/services/product_service.dart';

enum ViewState { idle, loading, error }

class ProductController extends GetxController {
  final ProductService service;

  ProductController({required this.service});

  var state = ViewState.idle.obs;
  var errorMessage = ''.obs;
  var products = <ProductModel>[].obs;

  var page = 1;
  final int limit = 10;
  var total = 0.obs;
  var isLoadingMore = false.obs;
  var isError = false.obs;

  bool get hasMore => products.length < total.value;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    page = 1;
    products.clear();
    total.value = 0;
    await _load(initial: true);
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;
    page++;
    await _load();
  }

  Future<void> _load({bool initial = false}) async {
    try {
      if (initial) {
        state.value = ViewState.loading;
      } else {
        isLoadingMore.value = true;
      }
      isError(false);

      final resp = await service.fetchProducts(page: page, limit: limit);
      if (page == 1) {
        products.clear();
      }
      products.addAll(resp.data);
      total.value = resp.total;

      state.value = ViewState.idle;
      errorMessage.value = '';
    } catch (e) {
      state.value = ViewState.error;
      errorMessage.value = e.toString();
      isError(true);
    } finally {
      isLoadingMore.value = false;
    }
  }
}
