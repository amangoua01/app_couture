import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter/material.dart';

extension TextEditingControllerExtension on TextEditingController {
  double toDouble() => text.toDouble().value;
  int toInt() => text.toInt().value;

  set setDouble(double? value) {
    text = value?.toString() ?? "0";
  }

  set setInt(int? value) {
    text = value?.toString() ?? "0";
  }
}
