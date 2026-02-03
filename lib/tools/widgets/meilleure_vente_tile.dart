import 'package:ateliya/data/models/meilleure_vente.dart';
import 'package:ateliya/data/models/paiement_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MeilleureVenteTile extends StatelessWidget {
  final MeilleureVente? meilleureVente;
  final PaiementBoutique? paiementBoutique;

  const MeilleureVenteTile({
    super.key,
    this.meilleureVente,
    this.paiementBoutique,
  }) : assert(meilleureVente != null || paiementBoutique != null,
            'Either meilleureVente or paiementBoutique must be provided');

  // Constructeur pour MeilleureVente
  const MeilleureVenteTile.fromMeilleureVente(MeilleureVente item, {super.key})
      : meilleureVente = item,
        paiementBoutique = null;

  // Constructeur pour PaiementBoutique
  const MeilleureVenteTile.fromPaiementBoutique(PaiementBoutique item,
      {super.key})
      : paiementBoutique = item,
        meilleureVente = null;

  @override
  Widget build(BuildContext context) {
    // Extraire les données selon le type
    final String titre =
        meilleureVente?.modeleNom ?? paiementBoutique?.reference ?? "Vente";
    final int quantite =
        meilleureVente?.quantiteTotale ?? paiementBoutique?.quantite ?? 0;
    final double montant =
        meilleureVente?.chiffreAffaires ?? paiementBoutique?.montant ?? 0.0;
    final client = meilleureVente?.client ?? paiementBoutique?.client;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.show_chart, color: AppColors.primary),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Gap(2),
                Text(
                  "$quantite vendu(s)",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                // Affichage du client si disponible
                if (client?.nomComplet != null &&
                    client!.nomComplet.isNotEmpty) ...[
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          client.nomComplet,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (client?.tel != null && client!.tel!.isNotEmpty) ...[
                  const Gap(2),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const Gap(4),
                      Text(
                        client.tel!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Gap(8),
          Text(
            montant.toAmount(unit: "FCFA"),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
