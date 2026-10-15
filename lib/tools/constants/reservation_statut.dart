import 'package:flutter/material.dart';

/// Statuts d'une réservation, tels que les renvoie l'API.
///
/// Les règles (ce qu'on peut confirmer, annuler) reprennent celles du serveur :
/// l'écran ne propose que les actions qu'il acceptera.
enum ReservationStatut {
  enAttente('en_attente', 'En attente', Color(0xFFB7791F), Icons.schedule_rounded),
  enAttenteStock(
    'en_attente_stock',
    'Stock à compléter',
    Color(0xFFC2410C),
    Icons.inventory_2_outlined,
  ),
  confirmee('confirmee', 'Confirmée', Color(0xFF2F7D5B), Icons.check_circle_rounded),
  annulee('annulee', 'Annulée', Color(0xFFB91C1C), Icons.cancel_rounded);

  final String code;
  final String label;
  final Color color;
  final IconData icon;

  const ReservationStatut(this.code, this.label, this.color, this.icon);

  static ReservationStatut fromCode(String? code) => ReservationStatut.values
      .firstWhere((s) => s.code == code, orElse: () => ReservationStatut.enAttente);

  /// Le serveur n'accepte la confirmation et l'annulation que sur ces deux états.
  bool get peutConfirmer => this == enAttente || this == enAttenteStock;
  bool get peutAnnuler => peutConfirmer;

  /// Un versement reste possible tant que la réservation n'est pas annulée.
  bool get peutRecevoirVersement => this != annulee;

  bool get manqueDeStock => this == enAttenteStock;
}
