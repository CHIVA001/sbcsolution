import 'dart:io';
import 'package:get/get.dart';

import '../model/sale_model.dart';
import '../service/sale_service.dart';

class SaleController extends GetxController {
  final service = SaleService();
  var sales = <SaleModel>[].obs;
  var isLoading = false.obs;
  var errorNetwork = false.obs;
  var errorMessage = ''.obs;
  var isError = false.obs;
  var selectedTab = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    if (sales.isEmpty) {
      fetchSales(type: 'all');
    }
  }

  Future<void> fetchSales({String type = 'all'}) async {
    try {
      isLoading(true);
      isError(false);
      errorNetwork(false);
      final fetchedSales = await service.fetchSales(type: type);
      sales.assignAll(fetchedSales);
    } on SocketException {
      await Future.delayed(Duration(milliseconds: 500));
      errorNetwork(true);
    } catch (e) {
      isError(true);
      errorMessage('Failed to load sales');
    } finally {
      isLoading(false);
    }
  }

  Future<void> changeTab(String tab) async {
    selectedTab.value = tab;
    fetchSales(type: tab);
  }
}
