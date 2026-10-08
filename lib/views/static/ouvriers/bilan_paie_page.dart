import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/build_summury_item.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/ouvriers/atelier_scope.dart';
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
          appBar: AppBar(
            title: Builder(
              builder: (_) {
                final atelier = mentionAtelierActif(ctl.getEntite().value);
                if (atelier == null) return const Text("Bilan des Paies");
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Bilan des Paies"),
                    Text(
                      atelier,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
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
                // Le montant étant désormais modifiable, « payer ce solde »
                // annoncerait à tort un règlement intégral obligatoire.
                title: "Effectuer un versement",
                isLoading: ctl.isPaying,
                onPressed:
                    () => _confirmerPaiement(context, employe, resteAPayer),
              ),
            ),
          ] else ...[
            // Sans ce repère, l'absence de bouton se lit comme un écran
            // incomplet plutôt que comme un solde réglé.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.25),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_rounded, size: 16, color: AppColors.green),
                    Gap(8),
                    Text(
                      "Tout est soldé pour cette période",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

    // Un ouvrier payé à la pièce se règle souvent en plusieurs fois : le
    // montant est donc modifiable, pré-rempli avec le solde restant pour que
    // le cas courant — tout solder d'un coup — reste un simple appui.
    final montantCtl = TextEditingController(text: montant.toStringAsFixed(0));
    String? erreur;

    double? montantSaisi() {
      final brut = montantCtl.text.replaceAll(RegExp(r'[^0-9.,]'), '')
          .replaceAll(',', '.');
      return double.tryParse(brut);
    }

    await Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Text(
                    "Confirmer le paiement",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const Gap(6),
                  Text(
                    "${employe['nomComplet'] ?? employe['nom']} — ${ctl.moisLabel}",
                    style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                  ),
                  const Gap(14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reste à payer",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "${montant.toStringAsFixed(0)} F",
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  CTextFormField(
                    controller: montantCtl,
                    externalLabel: "Montant à verser",
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    margin: EdgeInsets.zero,
                    suffixIcon: TextButton(
                      onPressed: () => setState(() {
                        montantCtl.text = montant.toStringAsFixed(0);
                        erreur = null;
                      }),
                      child: const Text(
                        "Tout solder",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  if (erreur != null) ...[
                    const Gap(6),
                    Text(
                      erreur!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                  const Gap(14),
                  CDropDownFormField<Caisse>(
                    externalLabel: "Caisse à débiter",
                    selectedItem: selected,
                    items: (filter, _) => caisses,
                    itemAsString: (c) => c.entite?.libelle ?? c.reference ?? "Caisse",
                    compareFn: (a, b) => a.id == b.id,
                    margin: EdgeInsets.zero,
                    onChanged: (c) => setState(() => selected = c),
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: CButton(
                          title: 'Annuler',
                          color: Colors.white,
                          textColor: AppColors.primary,
                          border: const BorderSide(color: AppColors.fieldBorder),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: CButton(
                          title: 'Confirmer',
                          enabled: selected != null,
                          onPressed: () async {
                            final saisi = montantSaisi();
                            if (saisi == null || saisi <= 0) {
                              setState(() =>
                                  erreur = "Saisissez un montant supérieur à 0.");
                              return;
                            }
                            // Verser plus que le solde fausserait le bilan :
                            // l'excédent serait compté comme déjà payé sur la
                            // période suivante.
                            if (saisi > montant + 0.001) {
                              setState(() => erreur =
                                  "Le montant dépasse le solde restant (${montant.toStringAsFixed(0)} F).");
                              return;
                            }
                            Get.back();
                            await ctl.payer(
                              employe['id'],
                              saisi,
                              caisseId: selected!.id,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
    montantCtl.dispose();
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
