import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
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

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => Get.to(() => DepenseDetailPage(depense: depense)),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Icon(Icons.receipt_long_rounded,
                              color: Color(0xFFDC2626), size: 22),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group != null ? "$category ($group)" : category,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Gap(4),
                            Text(
                              depense.createdAt.toFrenchDateTime,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if ((depense.description ?? '').isNotEmpty) ...[
                              const Gap(3),
                              Text(
                                depense.description!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontStyle: FontStyle.italic),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Gap(8),
                      Text(
                        "-${depense.montant.toAmount(unit: "FCFA")}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Color(0xFFB91C1C),
                            letterSpacing: -0.2),
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
