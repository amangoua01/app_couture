import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/constants/sens_mouvement_caisse_enum.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
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
          appBar: AppBar(
            title: Text(
              ctl.sens == SensMouvementCaisseEnum.entree
                  ? "Nouveau dépôt"
                  : "Nouveau retrait",
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () => BottomSheetDepot.show(ctl),
            elevation: 4,
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_card_rounded),
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
                  vertical: 5,
                ),
                child: CButton(
                  title:
                      ctl.sens == SensMouvementCaisseEnum.entree
                          ? "Enregistrer le dépôt"
                          : "Enregistrer le retrait",
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CDropDownFormField<ModePaiementEnum>(
                          externalLabel: "Mode de paiement",
                          selectedItem: ctl.modePaiement,
                          items:
                              (filter, loadProps) async =>
                                  ModePaiementEnum.values,
                          itemAsString: (item) => item.label,
                          onChanged: (e) {
                            if (e != null) {
                              ctl.modePaiement = e;
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
                          horizontal: 10,
                          vertical: 4,
                        ),
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
                      padding: EdgeInsets.zero,
                      itemCount: ctl.lines.length,
                      separatorBuilder: (context, index) => const Gap(12),
                      itemBuilder: (context, index) {
                        final line = ctl.lines[index];
                        final isEntree =
                            ctl.sens == SensMouvementCaisseEnum.entree;
                        final currentEntiteId = ctl.getEntite().value.id;
                        final isCurrentCaisse =
                            line.caisse?.entite?.id == currentEntiteId;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isCurrentCaisse
                                    ? AppColors.primary.withValues(alpha: 0.04)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isCurrentCaisse
                                      ? AppColors.primary.withValues(alpha: 0.3)
                                      : AppColors.primary.withValues(
                                        alpha: 0.15,
                                      ),
                              width: isCurrentCaisse ? 2.0 : 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  line.caisse?.entite?.libelle.value ??
                                      "Caisse",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Color(0xFF0F2620),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  controller: line.montantCtl,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color:
                                        isEntree
                                            ? AppColors.primary
                                            : Colors.red,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "0",
                                    suffixText: " F",
                                    filled: true,
                                    fillColor:
                                        isCurrentCaisse
                                            ? Colors.white
                                            : AppColors.primary.withValues(
                                              alpha: 0.03,
                                            ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (_) => ctl.update(),
                                ),
                              ),
                              if (ctl.lines.length > 1) ...[
                                const Gap(4),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () => ctl.removeLine(index),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ],
                          ),
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
