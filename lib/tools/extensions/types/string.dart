import 'dart:convert';
import 'dart:ui';

import 'package:ateliya/tools/components/functions.dart';
import 'package:get/get.dart';

extension StringExt on String? {
  String get value => this ?? "";

  DateTime? toDateTime() => DateTime.tryParse(toString());

  int? toInt() => int.tryParse(toString());

  double? toDouble() {
    var val = value;
    if (value.contains(",")) {
      val = value.replaceAll(",", ".");
    }
    return double.tryParse(val);
  }

  String get toFrenchDateTime => (this != null)
      ? Functions.getStringDate(toDateTime(), withTime: true)
      : "";

  String get toTime => (this != null) ? Functions.getTime(toDateTime()) : "";

  String get toFrenchDate =>
      (this != null) ? Functions.getStringDate(toDateTime()) : "";

  int? fromAmountToInt() {
    if (this == null) {
      return null;
    } else {
      var val = this!.replaceAll(RegExp(r'[^0-9-]'), '');
      return int.tryParse(val);
    }
  }

  double? fromAmountToDouble() {
    if (this == null) {
      return null;
    } else {
      var val = this!.replaceAll(RegExp(r'\s'), '');
      return double.tryParse(val);
    }
  }

  bool get isJson {
    if (this == null) {
      return false;
    } else {
      try {
        json.decode(this!);
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  String toAmount({
    String? unit,
    int? decimalDigits,
  }) =>
      Functions.formatMontant(
        this,
        devise: unit,
        decimalDigits: decimalDigits,
      );

  String defaultValue(String value) {
    if (this == null) {
      return value;
    } else {
      if (this!.isEmpty) {
        return value;
      } else {
        return this!;
      }
    }
  }

  String capitalize() {
    return value.capitalizeFirst.value;
  }

  Color? get toColor {
    if (this == null) return null;
    try {
      return Color(int.parse(this!, radix: 16));
    } catch (e) {
      return null;
    }
  }
}
