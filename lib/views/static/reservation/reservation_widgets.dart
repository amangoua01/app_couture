import 'package:ateliya/data/models/reservation.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/reservation_statut.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter/material.dart';

/// Pastille de statut : couleur et icône disent l'état avant même de lire.
class StatutChip extends StatelessWidget {
  final ReservationStatut statut;
  final bool grand;
  const StatutChip(this.statut, {super.key, this.grand = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: grand ? 12 : 9,
        vertical: grand ? 6 : 3,
      ),
      decoration: BoxDecoration(
        color: statut.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statut.icon, size: grand ? 16 : 13, color: statut.color),
          SizedBox(width: grand ? 6 : 4),
          Text(
            statut.label,
            style: TextStyle(
              fontSize: grand ? 13 : 11,
              fontWeight: FontWeight.w700,
              color: statut.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Barre d'avancement du paiement : la part déjà versée du montant total.
class ProgressionPaiement extends StatelessWidget {
  final Reservation reservation;
  const ProgressionPaiement(this.reservation, {super.key});

  @override
  Widget build(BuildContext context) {
    final solde = reservation.resteValue <= 0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: reservation.evolution.clamp(0.0, 1.0),
        minHeight: 6,
        backgroundColor: AppColors.primary.withValues(alpha: 0.08),
        color: solde ? AppColors.green : AppColors.secondary,
      ),
    );
  }
}

/// Délai avant le retrait, dit simplement et coloré quand il presse.
class DelaiRetrait {
  final String libelle;
  final Color couleur;
  const DelaiRetrait(this.libelle, this.couleur);

  static DelaiRetrait? de(Reservation r) {
    if (r.statut == ReservationStatut.annulee) return null;
    final date = DateTime.tryParse(r.dateRetrait ?? '');
    if (date == null) return null;

    final aujourdhui = DateTime.now();
    final jour = DateTime(date.year, date.month, date.day);
    final ref = DateTime(aujourdhui.year, aujourdhui.month, aujourdhui.day);
    final ecart = jour.difference(ref).inDays;

    // Une réservation déjà confirmée n'est plus « en retard » : elle attend
    // seulement d'être retirée.
    final actif = r.statut.peutConfirmer;
    if (ecart < 0) {
      return DelaiRetrait(
        actif
            ? 'En retard de ${-ecart} j'
            : 'Retrait prévu le ${r.dateRetrait.toFrenchDate}',
        actif ? const Color(0xFFB91C1C) : Colors.grey.shade600,
      );
    }
    if (ecart == 0)
      return const DelaiRetrait("Retrait aujourd'hui", Color(0xFFC2410C));
    if (ecart == 1)
      return const DelaiRetrait('Retrait demain', Color(0xFFB7791F));
    if (ecart <= 7) {
      return DelaiRetrait('Retrait dans $ecart jours', AppColors.primary);
    }
    return DelaiRetrait(
      'Retrait le ${r.dateRetrait.toFrenchDate}',
      Colors.grey.shade600,
    );
  }
}

/// « Tunique L ×2 » ou « Tunique L ×2 + 1 autre ».
String resumeArticles(Reservation r) {
  if (r.lignes.isEmpty) return 'Articles non détaillés';
  final premiere = r.lignes.first;
  final nom = premiere.modele?.modele?.libelle ?? 'Article';
  final taille =
      (premiere.modele?.taille ?? '').isEmpty
          ? ''
          : ' ${premiere.modele!.taille}';
  final suite =
      r.lignes.length > 1
          ? ' + ${r.lignes.length - 1} autre${r.lignes.length > 2 ? 's' : ''}'
          : '';
  return '$nom$taille ×${premiere.quantite ?? 1}$suite';
}

String montantF(double v) => v.toAmount(unit: 'F');
