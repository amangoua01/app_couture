import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

abstract class FieldBorder {
  static final enabled = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  );

  static final error = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.red,
    ),
  );

  static final disabled = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.grey,
    ),
  );

  static final enabledSearch = OutlineInputBorder(
    borderRadius: BorderRadius.circular(33),
    borderSide: const BorderSide(color: AppColors.primary),
  );
}
