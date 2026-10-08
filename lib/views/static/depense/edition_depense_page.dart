import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/tools/widgets/ligne_card.dart';
import 'package:ateliya/views/controllers/depense/edition_depense_page_vctl.dart';
import 'package:ateliya/views/static/depense/bottom_sheet_depense.dart';
import 'package:ateliya/views/static/depense/form_depense.dart';
import 'package:ateliya/services/gemini_assistant_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionDepensePage extends StatelessWidget {
  final DepenseExtractionResult? initialData;
  const EditionDepensePage({super.key, this.initialData});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionDepensePageVctl(initialData: initialData),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Nouvelle dépense"),
            elevation: 0,
            actions: [
              if (ctl.isAiPrefilled)
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 14, color: Color(0xFF92671A)),
                      Gap(4),
                      Text(
                        "IA Gemini",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92671A),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => BottomSheetDepense.show(context, ctl),
            elevation: 4,
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: CButton(
                  isLoading: ctl.isLoading,
                  onPressed: ctl.submit,
                  title: "Enregistrer la dépense",
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: ctl.formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  if (ctl.isAiPrefilled) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: Color(0xFF16A34A),
                            size: 20,
                          ),
                          Gap(10),
                          Expanded(
                            child: Text(
                              "Champs pré-remplis automatiquement par Gemini. Vérifiez et ajustez si besoin.",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  FormDepense(ctl: ctl),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.payments_outlined,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const Gap(8),
                          Text(
                            "Modes de règlement",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${ctl.ligneRows.length} règlement(s)",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  if (ctl.ligneRows.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const EmptyPage(
                        sizeIcon: 40,
                        icon: Icons.payments_outlined,
                        title: "Aucun mode de règlement ajouté",
                        subtitle:
                            "Saisissez un montant total puis ajoutez vos modes de règlement en cliquant sur le bouton ci-dessous.",
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: ctl.ligneRows.length,
                      separatorBuilder: (context, index) => const Gap(12),
                      itemBuilder: (context, index) {
                        final row = ctl.ligneRows[index];
                        return LigneCard(
                          index: index,
                          title: row.caisse!.entite!.libelle.value,
                          subtitle: "Prélèvement",
                          montant: row.montantCtl.text,
                          onDelete: () => ctl.removeLigne(index),
                          isEntree: false,
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
