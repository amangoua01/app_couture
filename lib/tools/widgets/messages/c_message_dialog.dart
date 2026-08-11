import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class CMessageDialog {
  static Future<void> show({
    required String? message,
    bool isSuccess = false,
  }) {
    // Configure EasyLoading background and style for dialogs to ensure readability
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = const Color(0xFF1E1E1E)
      ..textColor = Colors.white
      ..indicatorColor = Colors.white
      ..infoWidget =
          const Icon(Icons.info_outline, color: Colors.white, size: 40)
      ..successWidget = const Icon(Icons.check_circle_outline,
          color: Colors.greenAccent, size: 40)
      ..errorWidget =
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40)
      ..boxShadow = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        )
      ]
      ..contentPadding = const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 24.0,
      )
      ..radius = 16.0;

    if (isSuccess) {
      return EasyLoading.showSuccess(
        message.value,
        maskType: EasyLoadingMaskType.black,
      );
    } else {
      return EasyLoading.showError(
        message.value,
        maskType: EasyLoadingMaskType.black,
      );
    }
  }
}
