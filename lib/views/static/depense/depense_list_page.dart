import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/depense/depense_list_page_vctl.dart';
import 'package:ateliya/views/static/depense/depense_detail_page.dart';
import 'package:ateliya/views/static/depense/edition_depense_page.dart';
import 'package:ateliya/views/static/depense/gemini_assistant_sheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DepenseListPage extends StatelessWidget {
  const DepenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DepenseListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Mes dépenses",
          createPage: const EditionDepensePage(),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: InkWell(
                onTap: () => GeminiAssistantSheet.show(context),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0A3A30), Color(0xFF135E4E)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.secondary, size: 15),
                      Gap(4),
                      Text(
                        "IA Assistant",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          itemBuilder: (e, i, selected) {
            final depense = ctl.data.items[i];
            final category = depense.familleDepense?.libelle ?? 'Dépense générale';
            final group = depense.familleDepense?.groupeDepense?.libelle;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: const Color(0xFFDC2626).withOpacity(0.15), width: 1.5),
              ),
              color: Colors.white,
              child: InkWell(
                onTap: () => Get.to(() => DepenseDetailPage(depense: depense)),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(14)),
                        child: const Center(child: Icon(Icons.receipt_long_rounded, color: Color(0xFFDC2626), size: 22)),
                      ),
                      const Gap(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group != null ? "$category ($group)" : category,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Gap(4),
                            Text(
                              depense.createdAt.toFrenchDateTime,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "- ${depense.montant.toAmount(unit: "FCFA")}",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: Color(0xFFB91C1C), letterSpacing: -0.2),
                          ),
                          const Gap(4),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
