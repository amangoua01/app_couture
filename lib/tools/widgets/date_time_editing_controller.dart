import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/extensions/types/time_of_day.dart';
import 'package:flutter/material.dart';

class DateTimeEditingController {
  final TextEditingController _textController = TextEditingController();

  DateTime? _date;

  DateTimeEditingController();

  DateTimeEditingController.date(DateTime date) {
    this.date = date;
  }

  DateTimeEditingController.dateTime(DateTime date) {
    dateTime = date;
  }

  DateTime? get date => _date;

  set date(DateTime? value) {
    _date = value;
    _textController.text = value.toFrenchDate;
  }

  DateTime? get dateTime => _date;

  set dateTime(DateTime? value) {
    _date = value;
    _textController.text = value.toFrenchDateTime;
  }

  TextEditingController get textController => _textController;

  void clear() {
    _textController.clear();
    _date = null;
  }

  void dispose() {
    _textController.dispose();
  }

  set setTime(DateTime? value) {
    _date = value;
    _textController.text = value.toTime.toFrenchTime;
  }
}
