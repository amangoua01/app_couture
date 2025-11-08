import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/constants/env.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    fontFamily: Env.fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: false,
    primaryColor: AppColors.primary,
    primarySwatch: Colors.green,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20),
      titleMedium: TextStyle(fontSize: 15),
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    tabBarTheme: const TabBarThemeData(labelColor: Colors.white),
    buttonTheme: const ButtonThemeData(buttonColor: AppColors.primary),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  );
}
