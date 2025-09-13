import 'package:app_couture/tools/components/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension CustomDateTime on DateTime? {
  String get toFrenchDate =>
      (this != null) ? Functions.getStringDate(this) : "";
  String get toFrenchDateTime =>
      (this != null) ? Functions.getStringDate(this, withTime: true) : "";

  String get toTimeString => (this != null) ? Functions.getTime(this) : "";

  String? get toDateTimeString =>
      (this != null) ? this!.toIso8601String() : null;

  bool isSameDate(DateTime date2) {
    if (this != null) {
      return this!.day == date2.day &&
          this!.month == date2.month &&
          this!.year == date2.year;
    } else {
      return false;
    }
  }

  static nowWithoutTime() =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? addTime(TimeOfDay time) {
    if (this != null) {
      return DateTime(
        this!.year,
        this!.month,
        this!.day,
        time.hour,
        time.minute,
        this!.second,
        this!.millisecond,
        this!.microsecond,
      );
    } else {
      return null;
    }
  }

  TimeOfDay? get toTime {
    if (this != null) {
      return TimeOfDay(hour: this!.hour, minute: this!.minute);
    } else {
      return null;
    }
  }

  DateTime? setTimeOfDay(TimeOfDay time) {
    if (this == null) {
      return null;
    } else {
      return DateTime(
        this!.year,
        this!.month,
        this!.day,
        time.hour,
        time.minute,
      );
    }
  }

  TimeOfDay get toTimeOfDay => (this == null)
      ? TimeOfDay.now()
      : TimeOfDay(hour: this!.hour, minute: this!.minute);

  bool isSameTime(TimeOfDay time) {
    if (this == null) {
      return false;
    }
    return this!.hour == time.hour && this!.minute == time.minute;
  }

  /// Couvertir la date en string avec format yyyy-MM-dd HH:mm:ss.SSS
  String? toNotIsoFormat() {
    if (this == null) {
      return null;
    } else {
      // Formatter pour convertir la date au format souhaité
      DateFormat outputDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

      // Convertir l'objet DateTime en chaîne au format souhaité
      return outputDateFormat.format(this!);
    }
  }

  bool isPassedOf(DateTime other, {int nbDays = 1}) {
    final comparisonDate = other.add(Duration(days: nbDays));
    return this != null && this!.isBefore(comparisonDate);
  }
}
