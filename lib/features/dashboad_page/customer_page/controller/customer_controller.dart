import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../customer_model.dart';
import '../service/customer_service.dart';

enum ViewState { idle, loading, error, network }

class CustomerController extends GetxController {
  final service = CustomerService();
  final searchInputController = TextEditingController();

  var customers = <CustomerModel>[].obs;
  var state = ViewState.idle.obs;
  var errorMessage = ''.obs;
  var isError = false.obs;

  var searchTerm = ''.obs;
  var serverTotalCustomers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  /// Filter list based on search term
  RxList<CustomerModel> get filteredCustomers => customers
      .where((customer) {
        if (searchTerm.isEmpty) return true;
        final query = searchTerm.toLowerCase();
        return customer.name.toLowerCase().contains(query) ||
            customer.code.toLowerCase().contains(query);
      })
      .toList()
      .obs;

  /// Count totals
  int get totalCustomersCount => customers.length;

  int get activeCustomersCount =>
      filteredCustomers
          .where((c) => c.status.toLowerCase() == 'active')
          .length ;

  int get inactiveCustomersCount =>
      filteredCustomers.where((c) => c.status.toLowerCase() != 'active').length;

  /// Fetch all customers once
  Future<void> fetchCustomers() async {
    state(ViewState.loading);
    try {
      final response = await service.fetchAllCustomers();

      if (response.statusCode == 200) {
        final data = response.body as List<CustomerModel>;
        customers.assignAll(data);
        serverTotalCustomers(data.length + 1);
        state(ViewState.idle);
      } else {
        isError(true);
        state(ViewState.error);
        errorMessage('Error ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      state(ViewState.network);
    } catch (e) {
      state(ViewState.error);
      errorMessage(e.toString());
      isError(true);
    }
  }

  void onSearchChange(String value) {
    searchTerm(value.trim());
  }

  void clearSearch() {
    searchInputController.clear();
    searchTerm('');
  }
}
