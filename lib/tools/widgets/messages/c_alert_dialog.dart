import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CAlertDialog {
  static Future<T?> show<T>({
    required String title,
    String? message,
    required List<Widget> actions,
    Widget? content,
  }) {
    return Get.dialog<T>(
      AlertDialog(
        title: Text(title),
        content: content ?? Text(message.value),
        actions: actions,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Get.theme.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
