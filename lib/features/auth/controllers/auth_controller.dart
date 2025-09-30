import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cyspharama_app/bottom_nav_bar_page.dart';
import 'package:cyspharama_app/data/models/user_model.dart';
import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:cyspharama_app/services/auth_service.dart';
import 'package:cyspharama_app/services/storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
  void onInit() async {
    final getUserId = await _storage.readData('user_id');
    _userId = getUserId ?? "";
    // if (_userId != null) {
    //   _refreshTimer = Timer.periodic(
    //     const Duration(seconds: 3),
    //     (timer) => _refreshUser(),
    //   );
    // }

    WidgetsBinding.instance.addObserver(this);
    getProfile();
    _refreshUser();
    // _storage.readData('user_id').then((userId) {
    //   if (userId != null) {
    //     _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) => _refreshUser());
    //   }
    // });
    getCompanies();
    super.onInit();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
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
      final userData = await _service.getUser(_userId);
      _user(userData);
    } catch (e) {
      log("Profile refresh error: $e");
    }
  }

  Future<void> login(String username, String password) async {
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
      // _refreshUser();

      _isLoading(false);
      Get.snackbar("Login", "Welcome ${response.firstName}!");
      _message("Login successful");

      Get.offAll(() => BottomNavBarPage());
    } on SocketException {
      _errorNetwork(true);
    } catch (e) {
      _isLoading(false);
      _message("Login failed: ${e.toString()}");
      Get.snackbar(
        "Error",
        _message.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> getProfile() async {
    try {
      if (_userId != "") {
        final response = await _service.getProfile(userId: _userId);
        _user(response);
      }
    } on SocketException {
      _errorNetwork(true);
    } catch (e) {
      log("Profile refresh error: $e");
    }
  }

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
    _user(null);
    _refreshTimer?.cancel();
    Get.offAllNamed(AppRoutes.login);
  }
}
