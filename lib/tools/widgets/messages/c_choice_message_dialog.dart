import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/constants/env.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CChoiceMessageDialog {
  static Future<bool?> show({
    String title = Env.appName,
    required String message,
    Color secondaryColor = AppColors.primary,
    String validText = "Oui",
    String cancelText = "Non",
    double height = 150,
    double width = 200,
  }) =>
      Get.defaultDialog<bool>(
        title: title,
        barrierDismissible: false,
        contentPadding: const EdgeInsets.all(10),
        titlePadding: const EdgeInsets.only(top: 10),
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        confirmTextColor: Colors.white,
        actions: [
          MaterialButton(
            elevation: 0,
            textColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minWidth: 120,
            onPressed: () => Get.back(result: false),
            child: Text(
              cancelText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MaterialButton(
            minWidth: 120,
            elevation: 0,
            textColor: Colors.white,
            color: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () => Get.back(result: true),
            child: Text(
              validText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        content: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Center(child: Text(message, textAlign: TextAlign.center)),
        ),
      );
}
