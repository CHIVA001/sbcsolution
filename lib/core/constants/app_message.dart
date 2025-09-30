import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, error, warning, info }

void showCustomSnackbar({
  required String title,
  required String message,
  SnackbarType type = SnackbarType.info,
  SnackPosition position = SnackPosition.BOTTOM,
}) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackbarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case SnackbarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    case SnackbarType.warning:
      backgroundColor = Colors.orange;
      icon = Icons.warning;
      break;
    case SnackbarType.info:
    default:
      backgroundColor = Colors.blue;
      icon = Icons.info;
      break;
  }

  Get.snackbar(
    title,
    message,
    snackPosition: position,
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(12),
    borderRadius: 12,
    isDismissible: true,
    icon: Icon(icon, color: Colors.white),
  );
}
