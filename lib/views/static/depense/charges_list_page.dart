import 'package:ateliya/data/models/charge.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/shimmer_listtile.dart';
import 'package:ateliya/views/controllers/depense/charges_list_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Charges récurrentes de l'entreprise (ex: "Loyer atelier", "Salaire styliste")
class ChargesListPage extends StatelessWidget {
  const ChargesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChargesListVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7FAF8),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              onPressed: () => Get.back(),
            ),
            centerTitle: true,
            title: const Text(
              "Charges récurrentes",
              style: TextStyle(
                color: Color(0xFF0E2C24),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showFormSheet(context, ctl),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              "Nouvelle charge",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: ctl.fetchCharges,
            child: PlaceholderWidget(
              condition: !ctl.isLoading,
              placeholder: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                itemBuilder: (_, __) => const ShimmerListtile(),
              ),
              child: PlaceholderWidget(
                condition: ctl.charges.isNotEmpty,
                placeholder: const EmptyDataWidget(
                  message: "Aucune charge récurrente pour le moment.\nAjoutez vos salaires, loyers ou factures récurrentes.",
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: ctl.charges.length,
                  itemBuilder: (context, i) {
                    final charge = ctl.charges[i];
                    return _buildChargeCard(context, ctl, charge);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChargeCard(
    BuildContext context,
    ChargesListVctl ctl,
    Charge charge,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withOpacity(0.15), width: 1.5),
      ),
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showFormSheet(context, ctl, charge: charge),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icône récurrente
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.event_repeat_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
                const Gap(14),
                // Contenu central
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        charge.libelle ?? "Charge",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Color(0xFF0F2620),
                        ),
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          if (charge.familleDepense != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                charge.familleDepense!.libelle ?? "",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const Gap(6),
                          ],
                          if (charge.periodicite != null)
                            Text(
                              charge.periodicite!.label,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Montant & Action suppression
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      (charge.montant ?? "0").toAmount(unit: "FCFA"),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                    const Gap(4),
                    InkWell(
                      onTap: () => ctl.deleteCharge(charge),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 19,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFormSheet(
    BuildContext context,
    ChargesListVctl ctl, {
    Charge? charge,
  }) {
    final isEdit = charge != null;
    final libelleCtl = TextEditingController(text: charge?.libelle);
    final montantCtl = TextEditingController(text: charge?.montant);
    FamilleDepense? type = charge?.familleDepense;
    bool isSubmitting = false;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final keyboardHeight = MediaQuery.of(sheetContext).viewInsets.bottom;

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Poignée centrale
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const Gap(16),

                      // En-tête avec titre et bouton fermer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEdit ? "Modifier la charge" : "Nouvelle charge",
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F2620),
                            ),
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                      const Gap(16),

                      // Champ Libellé
                      CTextFormField(
                        controller: libelleCtl,
                        externalLabel: "Libellé*",
                        hintText: "Ex: Salaire Konaté",
                        require: true,
                      ),

                      // Champ Montant
                      CTextFormField(
                        controller: montantCtl,
                        externalLabel: "Montant*",
                        keyboardType: TextInputType.number,
                        require: true,
                        suffix: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "FCFA",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      // Dropdown Catégorie
                      CDropDownFormField<FamilleDepense>(
                        selectedItem: type,
                        onChanged: (e) => setSheetState(() => type = e),
                        items: (p0, p1) => ctl.getTypes(),
                        itemAsString: (p0) => p0.libelle ?? "",
                        externalLabel: "Type de dépense",
                        margin: const EdgeInsets.only(bottom: 24),
                      ),

                      // Bouton d'action avec indicateur de chargement
                      CButton(
                        title: isEdit ? "Enregistrer les modifications" : "Créer la charge",
                        isLoading: isSubmitting,
                        radius: 16,
                        height: 50,
                        fontWeight: FontWeight.w800,
                        onPressed: () async {
                          if (libelleCtl.text.trim().isEmpty ||
                              montantCtl.text.trim().isEmpty) {
                            Get.snackbar(
                              "Champs incomplets",
                              "Veuillez renseigner le libellé et le montant",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.shade700,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 14,
                            );
                            return;
                          }

                          setSheetState(() => isSubmitting = true);

                          final saved = await ctl.saveCharge(
                            Charge(
                              id: charge?.id,
                              libelle: libelleCtl.text.trim(),
                              montant: montantCtl.text.trim(),
                              familleDepense: type,
                            ),
                          );

                          setSheetState(() => isSubmitting = false);

                          if (saved) Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }
}
