import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/constants/sens_mouvement_caisse_enum.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/controllers/caisse/approvisionner_caisse_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ApprovisionnerCaissePage extends StatelessWidget {
  const ApprovisionnerCaissePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ApprovisionnerCaissePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Approvisionner caisse")),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddBottomSheet(context, ctl),
            icon: const Icon(Icons.add),
            label: const Text("Ajouter un montant"),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CButton(
                title: "Enregistrer le mouvement",
                onPressed: ctl.submit,
              ),
            ),
          ),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: CDropDownFormField<ModePaiementEnum>(
                    externalLabel: "Mode de paiement",
                    selectedItem: ctl.modePaiement,
                    items: (filter, loadProps) async => ModePaiementEnum.values,
                    itemAsString: (item) => item.label,
                    onChanged: (e) {
                      if (e != null) {
                        ctl.modePaiement = e;
                        ctl.update();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: CDropDownFormField<SensMouvementCaisseEnum>(
                    externalLabel: "Sens",
                    selectedItem: ctl.sens,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: CTextFormField(
                    externalLabel: "Description",
                    controller: ctl.descriptionCtl,
                    maxLines: 2,
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: ctl.lines.length,
                  separatorBuilder: (context, index) => const Gap(12),
                  itemBuilder: (context, index) {
                    return _LigneCaisseCard(index: index, ctl: ctl);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total cumulé :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ctl.totalMontant.toString().toAmount(unit: "F"),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(100), // Space for FAB
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddBottomSheet(
      BuildContext context, ApprovisionnerCaissePageVctl ctl) {
    Caisse? selectedCaisse;
    final TextEditingController montantCtl = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ajouter un montant',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Gap(16),
                CDropDownFormField<Caisse>(
                  externalLabel: "Sélectionner la caisse",
                  require: true,
                  selectedItem: selectedCaisse,
                  onChanged: (e) => setState(() => selectedCaisse = e),
                  items: (filter, loadProps) => ctl.getCaisses(),
                  itemAsString: (item) =>
                      "${item.entite?.libelle ?? "N/A"} (${item.montant?.toAmount(unit: 'F')})",
                ),
                const Gap(12),
                CTextFormField(
                  externalLabel: "Montant",
                  controller: montantCtl,
                  require: true,
                  keyboardType: TextInputType.number,
                  margin: EdgeInsets.zero,
                ),
                const Gap(24),
                CButton(
                  title: 'Ajouter au mouvement',
                  onPressed: () {
                    if (selectedCaisse == null) {
                      Get.snackbar('Erreur', 'Veuillez sélectionner une caisse',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }
                    if (montantCtl.text.isEmpty) {
                      Get.snackbar('Erreur', 'Veuillez saisir un montant',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    ctl.lines.add(ApprovisionnerCaissePageVctl.createLine(
                        selectedCaisse!, montantCtl.text));
                    ctl.update();
                    Get.back();
                  },
                ),
                const Gap(16),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}

class _LigneCaisseCard extends StatelessWidget {
  final int index;
  final ApprovisionnerCaissePageVctl ctl;

  const _LigneCaisseCard({required this.index, required this.ctl});

  @override
  Widget build(BuildContext context) {
    final line = ctl.lines[index];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.primary, size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.caisse?.entite?.libelle ?? "N/A",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "Montant : ${line.montantCtl.text.toAmount(unit: 'F')}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ctl.removeLine(index),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }
}
