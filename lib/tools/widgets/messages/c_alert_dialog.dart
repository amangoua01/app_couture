import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/env.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CAlertDialog {
  static Future<void> show({
    required String? message,
    bool barrierDismissible = true,
    List<Widget>? actions,
    Widget? confirm,
    TextStyle? titleStyle,
    void Function()? onConfirm,
    double radius = 10,
    Color primaryColor = AppColors.primary,
    String? title = Env.appName,
  }) =>
      Get.defaultDialog(
        textConfirm: "OK",
        buttonColor: primaryColor,
        confirmTextColor: Colors.white,
        title: title ?? "Message",
        titleStyle: titleStyle,
        confirm: confirm,
        content: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            message ?? "Erreur",
            textAlign: TextAlign.center,
          ),
        ),
        radius: radius,
        actions: actions,
        onConfirm: () => Get.back(),
        barrierDismissible: barrierDismissible,
      );
}
