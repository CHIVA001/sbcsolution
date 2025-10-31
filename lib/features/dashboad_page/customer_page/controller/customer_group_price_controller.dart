import 'dart:io';
import '../models/customer_group_model.dart';
import '../models/customer_price_group.dart';
import '/features/dashboad_page/customer_page/service/customer_price_group.dart';
import 'package:get/get.dart';

enum GViewState { idle, loading, error, network }

class CustomerGroupPriceController extends GetxController {
  final Rx<GViewState> _state = GViewState.idle.obs;
  GViewState get state => _state.value;
  final RxString errorMessage = ''.obs;
  // Gender
  var selectedGender = ''.obs;
  final genderList = ['Male', 'Female', 'Other'].obs;

  // customer group
  final customerGroup = <CustomerGroupModel>[].obs;
  final selectedCustomerGroup = Rxn<CustomerGroupModel>();
  // Customer price
  final CustomerPriceGroupService _service = CustomerPriceGroupService();
  final priceGroup = <CustomerPriceGroupModel>[].obs;
  final selectedPriceGroup = Rxn<CustomerPriceGroupModel>();
  Future<void> fetchCustomerPriceGroup() async {
    _state(GViewState.loading);
    errorMessage('');

    try {
      final reponse = await _service.getPriceGroup();
      priceGroup.assignAll(reponse);
    } on SocketException {
      _state(GViewState.network);
      errorMessage('No Internet connection');
    } catch (e) {
      _state.value = GViewState.error;
      errorMessage.value = e.toString();
    } finally {
      _state(GViewState.idle);
      errorMessage('');
    }
  }

  Future<void> fetchCustomerGroup() async {
    _state(GViewState.loading);
    errorMessage('');

    try {
      final reponse = await _service.getCustomerGroup();
      customerGroup.assignAll(reponse);
      // log('repons${reponse.length}');
    } on SocketException {
      _state(GViewState.network);
      errorMessage('No Internet connection');
    } catch (e) {
      _state.value = GViewState.error;
      errorMessage.value = e.toString();
    } finally {
      _state(GViewState.idle);
      errorMessage('');
    }
  }
}
