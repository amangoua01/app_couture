import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/reservation_statut.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

/// Article réservé : une ligne de la réservation.
class ReservationLigne {
  int? id;
  int? quantite;
  String? avanceModele;
  ModeleBoutique? modele;

  ReservationLigne.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    avanceModele = json['avanceModele']?.toString();
    final m = json['modele'];
    modele = m is Map<String, dynamic> ? ModeleBoutique.fromJson(m) : null;
  }

  /// Total de la ligne : quantité × prix unitaire.
  double get total => (quantite ?? 0) * (modele?.prix.toDouble().value ?? 0);
}

/// Versement enregistré sur la réservation (avance initiale ou complément).
class ReservationVersement {
  int? id;
  String? montant;
  String? reference;
  String? moyenPaiement;
  String? createdAt;

  ReservationVersement.fromJson(Json json) {
    id = json['id'];
    montant = json['montant']?.toString();
    reference = json['reference'];
    moyenPaiement = json['moyenPaiement'];
    createdAt = json['createdAt'];
  }
}

/// Étape de l'historique des statuts.
class ReservationEtape {
  String? ancien;
  String? nouveau;
  String? date;
  String? motif;

  ReservationEtape.fromJson(Json json) {
    ancien = json['oldStatus'];
    nouveau = json['newStatus'];
    date = json['changedAt'];
    motif = json['reason'];
  }
}

class Reservation extends ModelJson {
  String? montant;
  String? dateRetrait;
  String? avance;
  String? reste;
  Client? client;
  String? createdAt;
  bool? isActive;
  String status = ReservationStatut.enAttente.code;
  String? confirmedAt;
  String? cancelledAt;
  String? cancellationReason;
  List<ReservationLigne> lignes = [];
  List<ReservationVersement> versements = [];
  List<ReservationEtape> historique = [];

  Reservation({
    this.montant,
    this.dateRetrait,
    this.avance,
    this.reste,
    this.client,
    this.createdAt,
    this.isActive,
  });

  @override
  Reservation fromJson(Json json) {
    return Reservation.fromJson(json);
  }

  Reservation.fromJson(Json json) {
    id = json['id'];
    montant = json['montant'];
    dateRetrait = json['dateRetrait'];
    avance = json['avance'];
    reste = json['reste'];
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    status = json['status'] ?? status;
    confirmedAt = json['confirmedAt'];
    cancelledAt = json['cancelledAt'];
    cancellationReason = json['cancellationReason'];
    // Les éléments réduits à un identifiant (référence circulaire) ne sont
    // pas des objets : on les saute plutôt que de planter.
    lignes = _liste(json['ligneReservations'], ReservationLigne.fromJson);
    versements =
        _liste(json['paiementReservations'], ReservationVersement.fromJson);
    historique = _liste(json['statusHistory'], ReservationEtape.fromJson);
  }

  static List<T> _liste<T>(dynamic brut, T Function(Json) conversion) {
    if (brut is! List) return [];
    return brut.whereType<Map<String, dynamic>>().map(conversion).toList();
  }

  ReservationStatut get statut => ReservationStatut.fromCode(status);

  double get montantValue => montant.toDouble().value;
  double get avanceValue => avance.toDouble().value;
  double get resteValue => reste.toDouble().value;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['montant'] = montant;
    data['dateRetrait'] = dateRetrait;
    data['avance'] = avance;
    data['reste'] = reste;
    data['client'] = client?.id;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }

  double get evolution {
    if (montant == null || avance == null) {
      return 0.0;
    }
    final double montantValue = montant.toDouble().value;
    final double avanceValue = avance.toDouble().value;
    if (montantValue == 0.0) {
      return 0.0;
    }
    return (avanceValue / montantValue);
  }
}
