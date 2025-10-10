import 'dart:io';

import 'package:cyspharama_app/features/dashboad_page/sale/service/sale_service.dart';
import 'package:get/get.dart';

import '../model/sale_model.dart';

class SaleController extends GetxController {
  final service = SaleService();
  var sales = <SaleModel>[].obs;
  var isLoading = false.obs;
  var errorNetwork = false.obs;
  var errorMessage = ''.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  void fetchSales() async {
    try {
      isLoading(true);
      isError(false);
      errorNetwork(false);
      final fetchedSales = await service.fetchSales();
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
}
