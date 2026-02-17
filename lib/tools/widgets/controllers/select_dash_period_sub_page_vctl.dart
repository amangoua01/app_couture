import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectDashPeriodSubPageVctl extends GetxController {
  List<DateTime> selectedDateRange = [];

  SelectDashPeriodSubPageVctl(DateTimeRange initialDateRange) {
    selectedDateRange = [initialDateRange.start, initialDateRange.end];
  }

  void submit() {
    if (selectedDateRange.isNotEmpty) {
      final DateTimeRange date;
      if (selectedDateRange.length == 1) {
        date = DateTimeRange(
          start: selectedDateRange.first,
          end: selectedDateRange.first.setTimeOfDay(
            const TimeOfDay(hour: 23, minute: 59),
          )!,
        );
      } else if (selectedDateRange.length == 2) {
        date = DateTimeRange(
          start: selectedDateRange.first,
          end: selectedDateRange.last.setTimeOfDay(
            const TimeOfDay(hour: 23, minute: 59),
          )!,
        );
      } else {
        return;
      }
      Get.back(result: date);
    } else {
      CMessageDialog.show(
        message: "Veuillez choisir une plage de dates correcte.",
      );
    }
  }
}
