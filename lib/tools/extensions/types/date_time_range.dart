import 'package:app_couture/tools/extensions/types/datetime.dart';
import 'package:flutter/material.dart';

extension CustomDateTimeRange on DateTimeRange {
  String get toFrenchDate {
    if (end.isSameDate(start)) {
      return "A la date du ${end.toFrenchDate}";
    } else {
      return "Du ${start.toFrenchDate} au ${end.toFrenchDate}";
    }
  }

  static DateTimeRange now() {
    var now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day),
    );
  }
}
