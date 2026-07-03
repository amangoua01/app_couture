import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CSnackbar {
  static void success(String message) {
    _show(
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: AppColors.primary,
    );
  }

  static void error(String message) {
    _show(
      message: message,
      icon: Icons.error_rounded,
      backgroundColor: Colors.red.shade700,
    );
  }

  static void _show({
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      message: message,
      icon: Icon(icon, color: Colors.white, size: 24),
      backgroundColor: backgroundColor,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
