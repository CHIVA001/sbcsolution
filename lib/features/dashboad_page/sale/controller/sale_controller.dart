import 'package:cyspharama_app/features/dashboad_page/sale/service/sale_service.dart';
import 'package:get/get.dart';

import '../model/sale_model.dart';

class SaleController extends GetxController {
  final service = SaleService();
  var sales = <SaleModel>[].obs;
  var isLoading = false.obs;
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
      final fetchedSales = await service.fetchSales();
      sales.assignAll(fetchedSales);
    } catch (e) {
      isError(true);
      errorMessage('Failed to load sales');
    } finally {
      isLoading(false);
    }
  }
}
