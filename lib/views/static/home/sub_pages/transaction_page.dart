import 'dart:math';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/transaction_resume_tile.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            child: TableCalendar(
              locale: "fr",
              calendarFormat: CalendarFormat.week,
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(color: Colors.white),
                formatButtonTextStyle: TextStyle(color: Colors.white),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white),
                weekendStyle: TextStyle(color: AppColors.yellow),
              ),
              calendarStyle: const CalendarStyle(),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10, bottom: 100),
        children: [
          const SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TransactionResumeTile(
                    title: "Revenus",
                    value: "33 200",
                    color: Colors.green,
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: TransactionResumeTile(
                    title: "Dépenses",
                    value: "33 200",
                    color: Colors.red,
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: TransactionResumeTile(
                    title: "Total",
                    value: "33 200",
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Column(
            children: List.generate(
              10,
              (i) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Achat",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "CFA  ${Random().nextInt(200000).toAmount(unit: "")}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ternaryFn(
                              condition: Random().nextBool(),
                              ifTrue: Colors.green,
                              ifFalse: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Achat d’une nouvelle ma ...",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("12:21")
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
