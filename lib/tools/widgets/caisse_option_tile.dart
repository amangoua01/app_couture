import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Traduit le code technique renvoyé par le serveur en libellé lisible.
String caisseTypeLabel(String? type) {
  switch (type) {
    case 'boutique':
      return "Boutique";
    case 'caisse_succursale':
      return "Atelier";
    default:
      return "Caisse";
  }
}

IconData _caisseTypeIcon(String? type) {
  switch (type) {
    case 'boutique':
      return Icons.storefront_rounded;
    case 'caisse_succursale':
      return Icons.precision_manufacturing_rounded;
    default:
      return Icons.account_balance_wallet_rounded;
  }
}

/// Ligne d'une caisse dans un sélecteur : nom de l'entité, type en badge,
/// solde formaté — plutôt qu'une chaîne brute concaténant le code technique.
class CaisseOptionTile extends StatelessWidget {
  final Caisse caisse;
  final bool isSelected;

  const CaisseOptionTile({
    required this.caisse,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final label = caisseTypeLabel(caisse.type);
    return Container(
      color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _caisseTypeIcon(caisse.type),
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  caisse.entite?.libelle.value ?? "—",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const Gap(2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Text(
            (caisse.montant ?? "0").toAmount(unit: "FCFA"),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
