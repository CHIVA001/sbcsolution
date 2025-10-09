import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../customer_model.dart';
import '../service/customer_service.dart';

enum ViewState { idle, loading, error }

class CustomerController extends GetxController {
  final service = CustomerService();
  final searchInputController = TextEditingController();
  var customers = <CustomerModel>[].obs;
  var state = ViewState.idle.obs;
  var errorMessage = ''.obs;
  var isError = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;

  var searchTerm = ''.obs;

  int _start = 0;
  final int _limit = 20;

  var serverTotalCustomers = 0.obs;
  var serverTotal = 0.obs;
  int get totalCustomersCount {
    return searchTerm.isEmpty
        ? serverTotalCustomers.value
        : filteredCustomers.length;
  }

  int get activeCustomersCount =>
      filteredCustomers.where((c) => c.status.toLowerCase() == 'active').length;

  int get inactiveCustomersCount =>
      filteredCustomers.where((c) => c.status.toLowerCase() != 'active').length;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers(isRefresh: true);
  }

  RxList<CustomerModel> get filteredCustomers => customers
      .where((customer) {
        if (searchTerm.isEmpty) {
          return true;
        }
        final lowerCaseQuery = searchTerm.toLowerCase();
        return customer.name.toLowerCase().contains(lowerCaseQuery) ||
            customer.code.toLowerCase().contains(lowerCaseQuery);
      })
      .toList()
      .obs;

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

      final result = await service.fetchCustomers(
        // Call the updated service method
        start: _start,
        limit: _limit,
      );

      // *** ADDED: Update the server total count ***
      serverTotalCustomers(result.totalCount);

      if (result.customers.isEmpty || result.customers.length < _limit) {
        hasMore(false);
      }

      customers.addAll(result.customers);
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

  void onSearchChange(String value) {
    searchTerm(value.trim());
  }

  void clearShearch() {
    searchInputController.clear();
    searchTerm('');
  }
}
