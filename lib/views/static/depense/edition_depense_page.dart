import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/ligne_card.dart';
import 'package:ateliya/views/controllers/depense/edition_depense_page_vctl.dart';
import 'package:ateliya/views/static/depense/bottom_sheet_depense.dart';
import 'package:ateliya/views/static/depense/form_depense.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionDepensePage extends StatelessWidget {
  const EditionDepensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionDepensePageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Nouvelle dépense",
            ),
            elevation: 0,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: CButton(
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
                  FormDepense(ctl: ctl),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.payments_outlined,
                              size: 20, color: AppColors.primary),
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
                            horizontal: 10, vertical: 4),
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
                  const Gap(24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: CTextFormField(
                      controller: ctl.descriptionCtl,
                      externalLabel: "Notes / Description",
                      maxLines: 3,
                      margin: EdgeInsets.zero,
                      hintText: "Saisir une description (facultatif)",
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
