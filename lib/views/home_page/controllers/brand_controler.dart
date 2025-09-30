import 'dart:developer';
import 'package:get/get.dart';
import '../models/brand_model.dart';
import '../services/brand_service.dart';

enum BrandState { initial, loading, error }

class BrandController extends GetxController {
  var state = BrandState.initial.obs;
  var brandList = <BrandModel>[].obs;

  final BrandService _brandService = BrandService();

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    state(BrandState.loading);
    try {
      final response = await _brandService.getBrands();
      brandList.value = response;
      state(BrandState.initial);
    } catch (e) {
      state(BrandState.error);
      log('Brand fetch error: $e');
    }
  }
}
