import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/constants/sens_mouvement_caisse_enum.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/ligne_card.dart';
import 'package:ateliya/views/controllers/caisse/approvisionner_caisse_page_vctl.dart';
import 'package:ateliya/views/static/caisse/bottom_sheet_depot.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ApprovisionnerCaissePage extends StatelessWidget {
  final SensMouvementCaisseEnum sens;
  const ApprovisionnerCaissePage({
    this.sens = SensMouvementCaisseEnum.entree,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ApprovisionnerCaissePageVctl(sens),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text("Nouveau dépôt")),
          floatingActionButton: FloatingActionButton(
            onPressed: () => BottomSheetDepot.show(ctl),
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: CButton(
                  title: "Enregistrer le dépôt",
                  onPressed: ctl.submit,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CDropDownFormField<ModePaiementEnum>(
                          externalLabel: "Mode de paiement",
                          selectedItem: ctl.modePaiement,
                          items: (filter, loadProps) async =>
                              ModePaiementEnum.values,
                          itemAsString: (item) => item.label,
                          onChanged: (e) {
                            if (e != null) {
                              ctl.modePaiement = e;
                              ctl.update();
                            }
                          },
                        ),
                        CDropDownFormField<SensMouvementCaisseEnum>(
                          externalLabel: "Sens",
                          selectedItem: ctl.sens,
                          enabled: false,
                          fillColor: Colors.grey.shade100,
                          items: (filter, loadProps) async =>
                              SensMouvementCaisseEnum.values,
                          itemAsString: (item) => item.label,
                          onChanged: (e) {
                            if (e != null) {
                              ctl.sens = e;
                              ctl.update();
                            }
                          },
                        ),
                        CTextFormField(
                          externalLabel: "Description",
                          controller: ctl.descriptionCtl,
                          maxLines: 2,
                          margin: EdgeInsets.zero,
                          hintText: "Saisir une description (facultatif)",
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lignes de mouvement",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary.withValues(alpha: 0.8),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${ctl.lines.length} caisse(s)",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total cumulé",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ctl.totalMontant.toString().toAmount(unit: "F"),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  if (ctl.lines.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const EmptyPage(
                        sizeIcon: 40,
                        icon: Icons.wallet_rounded,
                        title: "Aucun montant saisi",
                        subtitle:
                            "Ajoutez les montants correspondants par caisse en cliquant sur le bouton ci-dessous.",
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: ctl.lines.length,
                      separatorBuilder: (context, index) => const Gap(12),
                      itemBuilder: (context, index) {
                        final line = ctl.lines[index];
                        return LigneCard(
                          index: index,
                          title: line.caisse!.entite!.libelle.value,
                          subtitle:
                              "${ctl.sens.label.value} • ${ctl.modePaiement.label.value}",
                          montant: line.montantCtl.text,
                          isEntree: ctl.sens == SensMouvementCaisseEnum.entree,
                          onDelete: () => ctl.removeLine(index),
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
