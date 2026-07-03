import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/depense/edition_depense_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FormDepense extends StatelessWidget {
  final EditionDepensePageVctl ctl;
  const FormDepense({super.key, required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          CDropDownFormField<FamilleDepense>(
            selectedItem: ctl.selectedFamille,
            onChanged: (e) {
              ctl.selectedFamille = e;
              ctl.update();
            },
            items: (p0, p1) => ctl.getFamilles(),
            itemAsString: (p0) => p0.libelle.value,
            externalLabel: "Famille de dépense",
            require: true,
          ),
          CTextFormField(
            controller: ctl.montantCtl,
            keyboardType: TextInputType.number,
            externalLabel: 'Montant Total',
            require: true,
            suffix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "FCFA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            margin: ctl.totalMontant > 0
                ? const EdgeInsets.only(bottom: 12)
                : EdgeInsets.zero,
          ),
          if (ctl.totalMontant > 0) ...[
            const Gap(6),
            LinearProgressIndicator(
              value: ctl.progress,
              backgroundColor: Colors.grey[100],
              valueColor: AlwaysStoppedAnimation<Color>(
                ctl.progress == 1.0 ? AppColors.primary : AppColors.secondary,
              ),
              minHeight: 10,
              borderRadius: BorderRadius.circular(6),
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Couverture paiement",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]),
                ),
                Text(
                  "${ctl.totalLignes.toInt()} / ${ctl.totalMontant.toInt()} FCFA (${(ctl.progress * 100).toStringAsFixed(1)}%)",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ctl.progress == 1.0
                          ? AppColors.primary
                          : AppColors.secondary),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
