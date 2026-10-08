import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:ateliya/views/static/mesure/sub_pages/info_paiement_sub_page.dart';
import 'package:ateliya/views/static/mesure/sub_pages/info_user_sub_page.dart';
import 'package:ateliya/views/static/mesure/sub_pages/list_piece_sub_page.dart';
import 'package:ateliya/views/static/mesure/sub_pages/recap_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionMesurePage extends StatelessWidget {
  const EditionMesurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditionMesurePageVctl>(
      init: EditionMesurePageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(title: const Text("Nouvelle commande")),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (ctl.page > 0)
                    TextButton.icon(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      label: const Text("Précédent"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onPressed: ctl.previousPage,
                    ),
                  const Spacer(),
                  SizedBox(
                    width: 130,
                    child: CButton(
                      title:
                          ctl.page + 1 == ctl.pages.length
                              ? "Valider"
                              : "Suivant",
                      onPressed: ctl.nextPage,
                      color: AppColors.primary,
                      icon: Icon(
                        ctl.page + 1 == ctl.pages.length
                            ? Icons.check
                            : Icons.arrow_forward,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              _StepHeader(ctl: ctl),

              // Contenu principal
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: ctl.pageCtl,
                      onPageChanged: (e) {
                        ctl.page = e;
                        ctl.update();
                      },
                      children: [
                        ListPieceSubPage(ctl),
                        InfoUserSubPage(ctl),
                        InfoPaiementSubPage(ctl),
                        RecapSubPage(ctl),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// En-tête d'étape : titre + repère "Étape X/N" au-dessus d'une barre de
/// progression segmentée. Remplace les cercles numérotés précédents, qui ne
/// montraient le titre que de l'étape active et laissaient les autres
/// muettes — ici le trajet complet reste visible d'un coup d'œil.
class _StepHeader extends StatelessWidget {
  final EditionMesurePageVctl ctl;
  const _StepHeader({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final step = ctl.pages[ctl.page];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      step.subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${ctl.page + 1}/${ctl.pages.length}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const Gap(14),
          Row(
            children: List.generate(ctl.pages.length, (index) {
              final isDone = index <= ctl.page;
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(
                    right: index == ctl.pages.length - 1 ? 0 : 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDone
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
