import 'package:get/get.dart';
import '../customer_model.dart';
import '../service/customer_service.dart';

enum ViewState { idle, loading, error }

class CustomerController extends GetxController {
  final service = CustomerService();

  var customers = <CustomerModel>[].obs;
  var state = ViewState.idle.obs;
  var errorMessage = ''.obs;
  var isError = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;

  int _start = 0;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers(isRefresh: true);
  }

  Future<void> fetchCustomers({bool isRefresh = false}) async {
    if (isLoadingMore.value || (!hasMore.value && !isRefresh)) return;
    try {
      if (isRefresh) {
        state(ViewState.loading);
        _start = 0;
        hasMore(true);
        customers.clear();
      } else {
        isLoadingMore(true);
      }
      isError(false);

      final fetched = await service.fetchCustomers(
        start: _start,
        limit: _limit,
      );

      if (fetched.isEmpty || fetched.length < _limit) {
        hasMore(false);
      }

      customers.addAll(fetched);
      _start = customers.length;
      state(ViewState.idle);
    } catch (e) {
      state(ViewState.error);
      errorMessage(e.toString());
      isError(true);
    } finally {
      isLoadingMore(false);
    }
  }
}
