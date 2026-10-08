import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/views/controllers/ouvriers/atelier_scope.dart';
import 'package:ateliya/views/controllers/ouvriers/ouvrier_list_page_vctl.dart';
import 'package:ateliya/views/static/ouvriers/edition_ouvrier_page.dart';
import 'package:ateliya/views/static/ouvriers/pointage_historique_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class OuvrierListPage extends StatelessWidget {
  const OuvrierListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OuvrierListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Ouvriers / Apprentis",
          subtitle: mentionAtelierActif(ctl.getEntite().value),
          createPage: const EditionOuvrierPage(),
          itemBuilder: (_, i, selected) {
            final item = ctl.data.items[i];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: CardStyle.decoration(),
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.to(() => EditionOuvrierPage(item: item))?.then((_) => ctl.getList()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                          child: const Icon(
                            Icons.engineering_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nomComplet ?? item.nom ?? "Sans nom",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(2),
                              Text(
                                item.poste ?? "Aucun poste",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: "Historique des pointages",
                          icon: const Icon(Icons.history_rounded, color: AppColors.primary),
                          onPressed: () => Get.to(() => PointageHistoriquePage(employe: item)),
                        ),
                      ],
                    ),
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
