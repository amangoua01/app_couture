import 'dart:math';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/views/controllers/home/transaction_bottom_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionBottomPage extends StatelessWidget {
  const TransactionBottomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TransactionBottomPageVctl(),
      builder: (ctl) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Historique des transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemCount: 10,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      ternaryFn(
                        condition: Random().nextBool(),
                        ifTrue: "assets/images/svg/entrant.png",
                        ifFalse: "assets/images/svg/sortant.png",
                      ),
                      width: 20,
                    ),
                  ),
                  title: const Text("Tranférer à daniel"),
                  subtitle: const Text(
                    "09H18, 08 septembre",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "8 000 FCFA",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Paiement facture",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
