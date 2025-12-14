import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/controllers/select_dash_period_sub_page_vctl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SelectDashPeriodSubPage extends StatelessWidget {
  final DateTimeRange selectedDateRange;
  const SelectDashPeriodSubPage(this.selectedDateRange, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SelectDashPeriodSubPageVctl(selectedDateRange),
      builder: (ctl) {
        return ListView(
          children: [
            CalendarDatePicker2(
              value: [selectedDateRange.start, selectedDateRange.end],
              config: CalendarDatePicker2Config(
                lastDate: DateTime.now(),
                calendarType: CalendarDatePicker2Type.range,
                allowSameValueSelection: true,
              ),
              onValueChanged: (dates) {
                ctl.selectedDateRange = dates;
              },
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: CButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: ctl.submit,
              ),
            ),
          ],
        );
      },
    );
  }
}
