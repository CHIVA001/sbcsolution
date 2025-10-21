import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../bottom_nav_bar_page.dart';
import '../../../core/handle/handle_error.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/storage_service.dart';

class AuthController extends GetxController with WidgetsBindingObserver {
  final _service = AuthService();
  final _storage = StorageService();

  final _user = Rx<UserModel?>(null);
  Rx<UserModel?> get user => _user;

  final _companies = <CompanyData>[].obs;
  RxList<CompanyData> get companies => _companies;

  final _errorNetwork = false.obs;
  RxBool get errorNetwork => _errorNetwork;

  final _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  final _message = "".obs;
  RxString get message => _message;

  Timer? _refreshTimer;
  String _userId = "";

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    _initializeUser();
    refreshUser();
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> _initializeUser() async {
    final getUserId = await _storage.readData('user_id');
    _userId = getUserId ?? "";
    // if (_userId.isNotEmpty) {
    //   _refreshTimer = Timer.periodic(
    //     const Duration(seconds: 2),
    //     (timer) => _refreshUser(),
    //   );
    // }
    _refreshUser();
    getCompanies();
  }

  Future<void> _refreshUser() async {
    try {
      final userData = await _service.getUser(_userId);
      _user(userData);
      if (userData.active == '0') {
        // log("User status is false, logging out.");
        await logout();
      }
    } catch (e) {
      // log("Profile refresh error: $e");
      if (user.value != null) {
        // log("Logging out due to profile refresh error.");
        await logout();
      }
    }
  }

  Future<void> refreshUser() async {
    try {
      final userId = await _storage.readData('user_id');
      if (userId == null || userId.isEmpty) return;
      _userId = userId;
      final userData = await _service.getUser(_userId);
      _user(userData);
    } catch (e) {
      log("Profile refresh error: $e");
    }
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      MessageDialog.error("Username and Password cannot be empty!");
      return;
    }
    _isLoading(true);
    _message("");

    try {
      final response = await _service.login(username, password);
      _user(response);
      await _storage.writeData('user_id', response.id);
      await _storage.writeData('emp_id', response.empId);

      // Start the periodic refresh timer
      // _refreshTimer = Timer.periodic(
      //   const Duration(seconds: 10),
      //   (timer) => _refreshUser(),
      // );
      // getProfile();
      _isLoading(false);
      // Get.snackbar("Login", "Welcome ${response.firstName}!");
      _message("Login successful");
      refreshUser();
      Get.offAllNamed(AppRoutes.navBar);
    } on SocketException {
      _errorNetwork(true);
    } catch (e) {
      _isLoading(false);
      try {
        await _service.login(username, password);
      } catch (e) {
        final message = e.toString();
        // You can extract only message text if needed:
        final cleanMessage = message.replaceAll("Exception:", "").trim();
        MessageDialog.error(cleanMessage);
      }
    }
  }

  // Future<void> getProfile() async {
  //   try {
  //     if (_userId != "" || _userId.isNotEmpty) {
  //       final response = await _service.getProfile(userId: _userId);
  //       _user(response);
  //     }
  //   } on SocketException {
  //     _errorNetwork(true);
  //   } catch (e) {
  //     log("Profile refresh error: $e");
  //   }
  // }

  // get companies
  Future<void> getCompanies() async {
    try {
      isLoading(true);
      final response = await _service.getCompany();
      _companies.assignAll(response.data ?? []);
    } catch (e) {
      isLoading(false);
      log("Error get company: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    await _storage.deleteData('user_id');
    await _storage.deleteData('emp_id');
    await _storage.deleteData('shift_id');
    _user(null);
    _refreshTimer?.cancel();
    Get.offAllNamed(AppRoutes.login);
  }
}
