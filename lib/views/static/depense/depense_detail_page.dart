import 'package:ateliya/data/models/depense.dart';
import 'package:ateliya/data/models/ligne_depense_caisse.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/caisse_option_tile.dart'
    show caisseTypeLabel;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DepenseDetailPage extends StatelessWidget {
  final Depense depense;
  const DepenseDetailPage({super.key, required this.depense});

  @override
  Widget build(BuildContext context) {
    final lignes = depense.depenseCaisses ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        title: const Text("Détail de la dépense"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (Montant et Date), dans le même langage visuel sombre
            // en dégradé que le reste de l'app plutôt qu'un fond clair
            // générique.
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Gap(14),
                  Text(
                    depense.montant.toAmount(unit: "FCFA"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                        const Gap(6),
                        Text(
                          depense.createdAt.toFrenchDateTime,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Informations générales
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) {
                  final rows = <Widget>[
                    if ((depense.familleDepense?.libelle ?? "").isNotEmpty)
                      _InfoRow(
                        icon: Icons.sell_outlined,
                        label: "Catégorie",
                        value: depense.familleDepense!.libelle!,
                      ),
                    if ((depense.familleDepense?.groupeDepense?.libelle ?? "").isNotEmpty)
                      _InfoRow(
                        icon: Icons.category_outlined,
                        label: "Groupe de charge",
                        value: depense.familleDepense!.groupeDepense!.libelle!,
                      ),
                    // Toujours affichée (contrairement à Catégorie/Groupe) : une
                    // note vide reste une information ("rien n'a été précisé"),
                    // pas une ligne à masquer.
                    _InfoRow(
                      icon: Icons.notes_rounded,
                      label: "Note",
                      value: (depense.description ?? "").isNotEmpty
                          ? depense.description!
                          : "Aucune note ajoutée",
                      muted: (depense.description ?? "").isEmpty,
                    ),
                  ];

                  return Column(
                    children: [
                      for (var i = 0; i < rows.length; i++) ...[
                        if (i > 0) Divider(height: 1, indent: 58, color: Colors.grey.shade100),
                        rows[i],
                      ],
                    ],
                  );
                },
              ),
            ),

            // Caisses
            if (lignes.isNotEmpty) ...[
              const Gap(16),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 15,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                    const Gap(8),
                    Text(
                      "PRÉLÈVEMENT SUR LES CAISSES",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary.withValues(alpha: 0.6),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < lignes.length; i++) ...[
                      if (i > 0) Divider(height: 1, indent: 68, color: Colors.grey.shade100),
                      _LigneReglementTile(
                        ligne: lignes[i],
                        totalDepense: double.tryParse(depense.montant ?? '0') ?? 0,
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const Gap(20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline_rounded, size: 13, color: Colors.grey.shade400),
                  const Gap(6),
                  Text(
                    "Dépense enregistrée · lecture seule",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LigneReglementTile extends StatelessWidget {
  final LigneDepenseCaisse ligne;
  final double totalDepense;
  const _LigneReglementTile({required this.ligne, required this.totalDepense});

  @override
  Widget build(BuildContext context) {
    final montantLigne = double.tryParse(ligne.montant ?? '0') ?? 0;
    final part = totalDepense > 0 ? (montantLigne / totalDepense).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ligne.caisse?.entite?.libelle.value ?? "Caisse",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                        color: Color(0xFF0F2620),
                      ),
                    ),
                    if (ligne.caisse?.type != null) ...[
                      const Gap(2),
                      Text(
                        caisseTypeLabel(ligne.caisse!.type),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(10),
              Text(
                (ligne.montant ?? "0").toAmount(unit: "FCFA"),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (totalDepense > 0) ...[
            const Gap(10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: part,
                minHeight: 6,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const Gap(6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(part * 100).round()}% de la dépense",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool muted;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: muted ? FontWeight.w500 : FontWeight.w700,
                    fontStyle: muted ? FontStyle.italic : FontStyle.normal,
                    color: muted ? Colors.grey.shade400 : const Color(0xFF0F2620),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
