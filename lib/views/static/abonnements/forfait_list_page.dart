import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/views/static/abonnements/detail_forfait_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForfaitListPage extends StatelessWidget {
  const ForfaitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forfaits")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 215,
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Avantages Classic +",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      "5000 FCFA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                const Row(children: [
                  Icon(Icons.calendar_month_sharp, color: Colors.green),
                  Gap(10),
                  Expanded(
                    child: Text(
                      "Valable 1 mois",
                      maxLines: 1,
                    ),
                  ),
                ]),
                const Gap(10),
                const Text("Forfait standard avec fonctionnalités avancées."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () => CBottomSheet.show(
                        child: const DetailForfaitSubPage(),
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: AppColors.primary.withAlpha(40),
                      child: const Text("Voir détails"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
