import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/build_summury_item.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/ouvriers/bilan_paie_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BilanPaiePage extends StatelessWidget {
  const BilanPaiePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BilanPaiePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Bilan des Paies")),
          body: Column(
            children: [
              _MoisSelector(ctl: ctl),
              Expanded(
                child:
                    ctl.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ctl.bilans.isEmpty
                        ? const Center(
                          child: Text(
                            "Aucun employé pour cette période",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: ctl.chargerBilan,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: ctl.bilans.length,
                            itemBuilder:
                                (context, index) => _BilanCard(
                                  bilan: ctl.bilans[index],
                                  ctl: ctl,
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

class _MoisSelector extends StatelessWidget {
  final BilanPaiePageVctl ctl;
  const _MoisSelector({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: ctl.moisPrecedent,
            icon: const Icon(Icons.chevron_left, color: AppColors.primary),
          ),
          Text(
            ctl.moisLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            onPressed: ctl.peutAvancer ? ctl.moisSuivant : null,
            icon: Icon(
              Icons.chevron_right,
              color: ctl.peutAvancer ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}

class _BilanCard extends StatelessWidget {
  final dynamic bilan;
  final BilanPaiePageVctl ctl;
  const _BilanCard({required this.bilan, required this.ctl});

  @override
  Widget build(BuildContext context) {
    final employe = bilan['employe'];
    final resteAPayer = (bilan['resteAPayer'] as num?)?.toDouble() ?? 0;
    final piecesParType = (bilan['piecesParType'] as List?) ?? [];
    final charges = (bilan['charges'] as List?) ?? [];
    final paiements = (bilan['paiements'] as List?) ?? [];
    final nbPieces = bilan['piecesTerminees'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: CardStyle.decoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : nom + reste à payer
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                  child: Text(
                    employe['nomComplet'] ?? employe['nom'] ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        resteAPayer > 0
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          resteAPayer > 0
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                    ),
                  ),
                  child: Text(
                    "Reste: ${resteAPayer.toStringAsFixed(0)} F",
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          resteAPayer > 0
                              ? Colors.red.shade700
                              : Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Activité du mois : pièces + heures, en mini-stats côte à côte
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: "Pièces",
                    value: "$nbPieces",
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: _MiniStat(
                    label: "Heures",
                    value: "${bilan['heuresTravaillees']}",
                    icon: Icons.schedule_outlined,
                  ),
                ),
              ],
            ),
          ),

          if (piecesParType.isNotEmpty) ...[
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final p in piecesParType)
                    _Tag(
                      "${p['libelle']}: ${p['quantite']}",
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          ],

          if (charges.isNotEmpty) ...[
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final c in charges)
                    _Tag(
                      "${c['libelle']}: ${(c['montant'] as num?)?.toStringAsFixed(0) ?? 0} F",
                      color: Colors.blueGrey,
                      icon: Icons.event_repeat_rounded,
                    ),
                ],
              ),
            ),
          ],

          const Gap(14),
          Divider(height: 1, color: Colors.grey.shade100),

          // Résumé financier
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                BuildSummuryItem(
                  label: "Gain pièces",
                  value:
                      "${(bilan['montantPieces'] as num?)?.toStringAsFixed(0) ?? 0} F",
                  color: AppColors.primary,
                ),
                BuildSummuryItem(
                  label: "Charges fixes",
                  value:
                      "${(bilan['montantCharges'] as num?)?.toStringAsFixed(0) ?? 0} F",
                  color: AppColors.secondary,
                ),
                BuildSummuryItem(
                  label: "Déjà payé",
                  value:
                      "${(bilan['dejaPaye'] as num?)?.toStringAsFixed(0) ?? 0} F",
                  color: AppColors.green,
                ),
                Divider(height: 20, color: Colors.grey.shade100),
                BuildSummuryItem(
                  label: "Reste à payer",
                  value: "${resteAPayer.toStringAsFixed(0)} F",
                  color: resteAPayer > 0 ? Colors.red.shade700 : AppColors.green,
                  isBold: true,
                ),
              ],
            ),
          ),

          if (paiements.isNotEmpty) ...[
            const Gap(6),
            Divider(height: 1, color: Colors.grey.shade100),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Historique des paiements",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary.withValues(alpha: 0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Gap(8),
                  for (final p in paiements)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: AppColors.green,
                          ),
                          const Gap(6),
                          Expanded(
                            child: Text(
                              "${p['date'] ?? ''}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Text(
                            "${(p['montant'] as num?)?.toStringAsFixed(0) ?? 0} F",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],

          if (resteAPayer > 0) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: CButton(
                title: "Payer ce solde",
                isLoading: ctl.isPaying,
                onPressed:
                    () => _confirmerPaiement(context, employe, resteAPayer),
              ),
            ),
          ] else
            const Gap(16),
        ],
      ),
    );
  }

  Future<void> _confirmerPaiement(
    BuildContext context,
    dynamic employe,
    double montant,
  ) async {
    final caisses = await ctl.getCaisses();
    if (caisses.isEmpty) {
      CMessageDialog.show(message: "Aucune caisse disponible pour cette entreprise");
      return;
    }

    // Caisse de l'atelier de l'employé par défaut, sinon la première
    // caisse de l'entreprise — le patron peut toujours en choisir une
    // autre avant de confirmer.
    final succursaleId = employe['succursaleId'];
    Caisse? selected = caisses.firstWhereOrNull(
          (c) => c.entite?.id != null && c.entite!.id == succursaleId,
        ) ??
        caisses.first;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Confirmer le paiement"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payer ${montant.toStringAsFixed(0)} FCFA à ${employe['nomComplet'] ?? employe['nom']} pour ${ctl.moisLabel} ?",
                ),
                const Gap(16),
                CDropDownFormField<Caisse>(
                  externalLabel: "Caisse à débiter",
                  selectedItem: selected,
                  items: (filter, _) => caisses,
                  itemAsString: (c) => c.entite?.libelle ?? c.reference ?? "Caisse",
                  compareFn: (a, b) => a.id == b.id,
                  margin: EdgeInsets.zero,
                  onChanged: (c) => setState(() => selected = c),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: selected == null
                    ? null
                    : () async {
                        Get.back();
                        await ctl.payer(employe['id'], montant, caisseId: selected!.id);
                      },
                child: const Text(
                  "Confirmer",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MiniStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary.withValues(alpha: 0.6)),
          const Gap(8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
          const Gap(4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const _Tag(this.text, {required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const Gap(4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
