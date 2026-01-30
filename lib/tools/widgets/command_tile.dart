import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/widgets/paiement_dialog.dart';
import 'package:ateliya/views/static/commandes/detail_command_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommandTile extends StatelessWidget {
  final Mesure? mesure;
  const CommandTile({super.key, this.mesure});

  @override
  Widget build(BuildContext context) {
    if (mesure == null) return const SizedBox.shrink();

    final pourcentage = (mesure!.montantTotal > 0)
        ? (mesure!.avance / mesure!.montantTotal)
        : 0.0;
    final bool isPaid = pourcentage >= 1.0;

    return GestureDetector(
      onTap: () => Get.to(() => DetailCommandPage(mesure: mesure)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    mesure!.client?.fullName ?? 'Client inconnu',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mesure!.dateRetrait?.toFrenchDateTime ?? "N/A",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Text(
              mesure!.lignesMesures
                  .map((e) => e.typeMesure?.libelle ?? "Article")
                  .join(", "),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(15),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pourcentage,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPaid ? Colors.green : AppColors.primary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ),
                const Gap(10),
                Text(
                  '${(pourcentage * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isPaid ? Colors.green : AppColors.primary,
                  ),
                ),
              ],
            ),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Avance",
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    Text(
                      mesure!.avance.toAmount(unit: "F"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total",
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                        Text(
                          mesure!.montantTotal.toAmount(unit: "F"),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (mesure!.resteArgent > 0) ...[
                      const Gap(10),
                      GestureDetector(
                        onTap: () async {
                          await Get.dialog(PaiementDialog(mesure: mesure!));
                          // Refresh logic could be added here if parent controller is accessible
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.payment,
                              color: AppColors.primary, size: 20),
                        ),
                      )
                    ]
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
