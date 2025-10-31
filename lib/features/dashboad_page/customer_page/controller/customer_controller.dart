import 'dart:developer';
import 'dart:io';
import 'package:cyspharama_app/features/dashboad_page/customer_page/models/add_cusomer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/handle/handle_error.dart';
import '../models/customer_model.dart';
import '../service/customer_service.dart';
import 'customer_group_price_controller.dart';

enum CViewState { idle, loading, error, network }

class CustomerController extends GetxController {
  final group = Get.find<CustomerGroupPriceController>();
  final service = CustomerService();
  final searchInputController = TextEditingController();

  var customers = <CustomerModel>[].obs;
  var state = CViewState.idle.obs;
  var errorMessage = ''.obs;
  var isError = false.obs;

  /*
      Controller 
  */

  //
  final name = TextEditingController();
  final gender = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();
  final address = TextEditingController();
  final note = TextEditingController();
  // locations
  final locationName = TextEditingController();
  final locationAddress = TextEditingController();
  final locationCity = TextEditingController();
  final locationPhone = TextEditingController();

  ///////////////////////////////////////

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
      filteredCustomers.where((c) => c.status.toLowerCase() == 'active').length;

  int get inactiveCustomersCount =>
      filteredCustomers.where((c) => c.status.toLowerCase() != 'active').length;

  /// Fetch all customers once
  Future<void> fetchCustomers() async {
    state(CViewState.loading);
    try {
      final response = await service.fetchAllCustomers();

      if (response.statusCode == 200) {
        final data = response.body as List<CustomerModel>;
        customers.assignAll(data);
        serverTotalCustomers(data.length + 1);
        state(CViewState.idle);
      } else {
        isError(true);
        state(CViewState.error);
        errorMessage('Error ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      state(CViewState.network);
    } catch (e) {
      state(CViewState.error);
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

  ///////////////

  // add customer
  Future<bool> addCustomer() async {
    if (name.text.isEmpty ||
        phone.text.isEmpty ||
        city.text.isEmpty ||
        address.text.isEmpty ||
        group.selectedGender.value.isEmpty ||
        group.selectedCustomerGroup.value == null ||
        group.selectedPriceGroup.value == null ||
        locationName.text.isEmpty ||
        locationAddress.text.isEmpty ||
        locationCity.text.isEmpty ||
        locationPhone.text.isEmpty) {
      AlertMessage.show(
        title: "Informations",
        middleText: "Please fill in all required fields before continuing.",
      );
      return false;
    }
    try {
      final response = await service.addCustomer(
        AddCustomerModel(
          date: DateTime.now().toString(),
          customerGroupId: int.parse(
            group.selectedCustomerGroup.value?.id ?? '1',
          ),
          priceGroupId: int.parse(group.selectedPriceGroup.value?.id ?? '1'),
          company: "-",
          name: name.text.trim(),
          phone: phone.text.trim(),
          email: null,
          city: city.text.trim(),
          note: note.text.trim(),
          address: address.text.trim(),
          gender: group.selectedGender.value.toLowerCase(),
          savePoint: 1,
          locations: [
            LocationModel(
              name: locationName.text.trim(),
              address: locationAddress.text.trim(),
              city: locationCity.text.trim(),
              phone: locationPhone.text.trim(),
              latitude: "0.0",
              longitude: "0.0",
            ),
          ],
        ),
      );

      if (response) {
        log('data: $response');
        Get.back();
        clearAll();
        HandleMessage.success('Customer added successfully!');
        await fetchCustomers();
        return true;
      } else {
        HandleMessage.success('Could not add customer. Please try again.');
        return false;
      }
    } catch (e, stackTrace) {
      log('Error adding customer: $e');
      log('Stack trace: $stackTrace');
      Get.snackbar(
        "⚠️ Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.2),
        colorText: Colors.black,
      );
      return false;
    }
  }

  void clearAll() {
    // Clear text fields
    name.clear();
    phone.clear();
    city.clear();
    address.clear();
    note.clear();

    locationName.clear();
    locationAddress.clear();
    locationCity.clear();
    locationPhone.clear();

    // Reset dropdowns
    group.selectedGender.value = '';
    group.selectedCustomerGroup.value = null;
    group.selectedPriceGroup.value = null;
  }
}
