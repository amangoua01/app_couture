import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/command_tile.dart';
import 'package:ateliya/tools/widgets/vente_tile.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ActivitePart extends StatelessWidget {
  final HomePageVctl ctl;
  const ActivitePart({super.key, required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    ctl.activiteTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Gap(8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${ctl.activiteItemCount}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ctl.goToActiviteList,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Voir plus",
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Gap(4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.secondary,
                      size: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(14),
        if (ctl.activiteItemCount == 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: AppColors.ligthGrey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.fieldBorder.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                Icon(ctl.activiteEmptyIcon, size: 40, color: AppColors.primary),
                const Gap(12),
                Text(
                  ctl.activiteEmptyMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 20),
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, i) => const Gap(10),
            itemCount: ctl.activiteItemCount,
            itemBuilder: (_, i) {
              if (ctl.isBoutique) {
                return VenteTile(
                  ctl.data.meilleuresVentes[i],
                  onDelete: ternaryFn(
                    condition: ctl.user.isAdmin,
                    ifTrue: (e) => ctl.deletePaiement(e.id.value),
                    ifFalse: null,
                  ),
                  onPrint: () => ctl.printVenteReceipt(
                    ctl.data.meilleuresVentes[i],
                    ctl.user.entreprise?.libelle ?? "Boutique",
                    footerMessage: ctl.user.settings?.messageFactureBoutique,
                  ),
                );
              } else {
                return CommandTile(mesure: ctl.data.commandes[i]);
              }
            },
          ),
      ],
    );
  }
}
