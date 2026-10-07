import 'package:ateliya/data/models/charge.dart';
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
          _ModeToggle(ctl: ctl),
          const Gap(16),
          if (ctl.isFromCharge) ...[
            CDropDownFormField<Charge>(
              selectedItem: ctl.selectedCharge,
              onChanged: ctl.applyCharge,
              items: (p0, p1) => ctl.getCharges(),
              itemAsString: (p0) => p0.libelle ?? "",
              externalLabel: "Charge récurrente",
              require: true,
            ),
            if (ctl.selectedCharge?.familleDepense != null) ...[
              _InheritedTypeChip(
                label: ctl.selectedCharge!.familleDepense!.libelle ?? "",
              ),
              const Gap(16),
            ],
          ] else
            CDropDownFormField<FamilleDepense>(
              selectedItem: ctl.selectedFamille,
              onChanged: (e) {
                ctl.selectedFamille = e;
                ctl.update();
              },
              items: (p0, p1) => ctl.getFamilles(),
              itemAsString: (p0) => p0.libelle.value,
              externalLabel: "Type de dépense",
              require: true,
            ),
          CTextFormField(
            controller: ctl.descriptionCtl,
            externalLabel: 'Motif / Description',
            hintText: 'Ex: Achat de fils, boutons, réparation...',
            require: false,
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
            margin:
                ctl.totalMontant > 0
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
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "${ctl.totalLignes.toInt()} / ${ctl.totalMontant.toInt()} FCFA (${(ctl.progress * 100).toStringAsFixed(1)}%)",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        ctl.progress == 1.0
                            ? AppColors.primary
                            : AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Bascule entre les deux parcours de création, pour que l'utilisateur sache
/// toujours dans quel mode il se trouve plutôt que de deviner à quoi sert
/// chaque champ.
class _ModeToggle extends StatelessWidget {
  final EditionDepensePageVctl ctl;
  const _ModeToggle({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: "Dépense simple",
              selected: !ctl.isFromCharge,
              onTap: () => ctl.setFromCharge(false),
            ),
          ),
          Expanded(
            child: _ModeButton(
              label: "Depuis une charge",
              selected: ctl.isFromCharge,
              onTap: () => ctl.setFromCharge(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

/// Rappelle, en lecture seule, le type hérité de la charge sélectionnée.
class _InheritedTypeChip extends StatelessWidget {
  final String label;
  const _InheritedTypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.sell_outlined, size: 16, color: AppColors.primary),
          const Gap(8),
          Expanded(
            child: Text(
              "Type hérité : $label",
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
