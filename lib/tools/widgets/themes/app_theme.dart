import 'package:flutter/material.dart';
import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/constants/env.dart';

abstract class AppTheme {
  static final light = ThemeData(
    fontFamily: Env.fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: false,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20),
      titleMedium: TextStyle(fontSize: 15),
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    tabBarTheme: const TabBarTheme(labelColor: AppColors.primary),
    buttonTheme: const ButtonThemeData(buttonColor: AppColors.primary),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
