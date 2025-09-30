import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weone_shop/app_route.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/views/home_page/services/storage_service.dart';
import 'package:weone_shop/views/nav_bar/nav_bar_app.dart';
import 'auth_service.dart';
import 'user_model.dart';

class AuthController extends GetxController {
  final StorageService _storage = StorageService();

  var user = Rxn<UserModel>();
  var isLoading = false.obs;
  var error = "".obs;
  var showPassword = false.obs;

  final AuthService _authService = AuthService();

  Future<void> login(String username, String password) async {
    try {
      isLoading(true);
      error("");
      final loggedInUser = await _authService.login(username, password);
      user.value = loggedInUser;

      Get.to(() => NavBarApp());

      await _storage.writeData('user_id', loggedInUser.id);
      await _storage.writeData('username', loggedInUser.username);
      await _storage.writeData('email', loggedInUser.email);
    } catch (e) {
      error(e.toString());
      CustomDialog.showError(
        "Login Failed",
        "Username & Password is not correct. Please try again.",
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    user.value = null;
    await _storage.clearAll();
    Get.offAndToNamed(AppRoute.login);
  }
}

class CustomDialog {
  static void showError(String title, String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.lightBgLight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.darkBgLight, fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static Future<bool> showConfirm(String title, String message) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.lightBgLight,
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.orange),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
