import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HandleMessage {
  // Success
  static void success(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Error
  static void error(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Warning
  static void warning(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Info
  static void info(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // No Network
  static void noNetwork() {
    Fluttertoast.showToast(
      msg: "No Internet Connection",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey.shade800,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class MessageDialog {
  static void networkError() {
    Get.defaultDialog(
      title: "Network Error",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: "There was an error connecting. Please check your internet.",
      middleTextStyle: const TextStyle(fontSize: 14),
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
      },
    );
  }

  static void error(String msg) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_rounded,
                  color: Colors.redAccent,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Error",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // 🆗 Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // user must tap OK
      transitionCurve: Curves.easeInOut,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void success(String msg) {
    Get.snackbar(
      "Success",
      msg,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class AttendanceDialog {
  static void confirmCheckIn({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.defaultDialog(
      title: "Check-In",
      titlePadding: EdgeInsets.symmetric(vertical: 16.0),
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: "Do you want to check-in now?",
      textCancel: "Cancel",
      cancelTextColor: Colors.red,
      textConfirm: "Confirm",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onCancel: () {
        if (onCancel != null) onCancel();
      },
      onConfirm: () {
        Get.back();
        onConfirm();
      },
    );
  }

  static void confirmCheckOut({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.defaultDialog(
      title: "Check-Out",
      titlePadding: EdgeInsets.symmetric(vertical: 16.0),
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: "Do you want to check-out now?",
      textCancel: "Cancel",
      cancelTextColor: Colors.red,
      textConfirm: "Confirm",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      onCancel: () {
        if (onCancel != null) onCancel();
      },
      onConfirm: () {
        Get.back();
        onConfirm();
      },
    );
  }
}

class AlertMessage {
  static void show({required String title, required String middleText}) {
    Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.symmetric(vertical: 16),
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black87,
      ),
      middleText: middleText,
      middleTextStyle: const TextStyle(fontSize: 16, color: Colors.black54),
      backgroundColor: Colors.white,
      radius: 15,
      contentPadding: const EdgeInsets.all(20),
      barrierDismissible: false,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: IconButton.styleFrom(minimumSize: Size(double.infinity, 45.0)),
        child: Text('OK'),
      ),
    );
  }
}
