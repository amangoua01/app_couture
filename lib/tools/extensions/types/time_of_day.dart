import 'package:flutter/material.dart';

extension CustomTimeOfDay on TimeOfDay? {
  String get toFrenchTime =>
      (this != null) ? "${this!.hour}:${this!.minute}" : "";
}
