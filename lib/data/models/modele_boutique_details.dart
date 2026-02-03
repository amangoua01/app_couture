import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class ModeleBoutiqueDetails extends ModelJson {
  List<MouvementStock> mouvements = [];
  List<ReservationItem> reservations = [];
  List<VenteItem> ventes = [];

  ModeleBoutiqueDetails({
    this.mouvements = const [],
    this.reservations = const [],
    this.ventes = const [],
  });

  ModeleBoutiqueDetails.fromJson(Json json) {
    if (json['mouvements'] != null) {
      mouvements = (json['mouvements'] as List)
          .map((e) => MouvementStock.fromJson(e))
          .toList();
    }
    if (json['reservations'] != null) {
      reservations = (json['reservations'] as List)
          .map((e) => ReservationItem.fromJson(e))
          .toList();
    }
    if (json['ventes'] != null) {
      ventes =
          (json['ventes'] as List).map((e) => VenteItem.fromJson(e)).toList();
    }
  }

  @override
  ModeleBoutiqueDetails fromJson(Json json) =>
      ModeleBoutiqueDetails.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'mouvements': mouvements.map((e) => e.toJson()).toList(),
      'reservations': reservations.map((e) => e.toJson()).toList(),
      'ventes': ventes.map((e) => e.toJson()).toList(),
    };
  }
}

// Mouvement de stock
class MouvementStock extends ModelJson {
  int? quantite;
  EntreeStock? entreStock;

  MouvementStock({this.quantite, this.entreStock});

  MouvementStock.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    if (json['entreStock'] != null) {
      entreStock = EntreeStock.fromJson(json['entreStock']);
    }
  }

  @override
  MouvementStock fromJson(Json json) => MouvementStock.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantite': quantite,
      'entreStock': entreStock?.toJson(),
    };
  }
}

class EntreeStock extends ModelJson {
  DateTime? date;
  int? quantite;
  String? type;
  String? statut;
  DateTime? createdAt;

  EntreeStock({
    this.date,
    this.quantite,
    this.type,
    this.statut,
    this.createdAt,
  });

  EntreeStock.fromJson(Json json) {
    id = json['id'];
    date = json['date'].toString().toDateTime();
    quantite = json['quantite'];
    type = json['type'];
    statut = json['statut'];
    createdAt = json['createdAt'].toString().toDateTime();
  }

  @override
  EntreeStock fromJson(Json json) => EntreeStock.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'quantite': quantite,
      'type': type,
      'statut': statut,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

// Réservation
class ReservationItem extends ModelJson {
  int? quantite;
  Reservation? reservation;
  String? avanceModele;
  DateTime? createdAt;

  ReservationItem({
    this.quantite,
    this.reservation,
    this.avanceModele,
    this.createdAt,
  });

  ReservationItem.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    if (json['reservation'] != null) {
      reservation = Reservation.fromJson(json['reservation']);
    }
    avanceModele = json['avanceModele'];
    createdAt = json['createdAt'].toString().toDateTime();
  }

  @override
  ReservationItem fromJson(Json json) => ReservationItem.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantite': quantite,
      'reservation': reservation?.toJson(),
      'avanceModele': avanceModele,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class Reservation extends ModelJson {
  String? montant;
  DateTime? dateRetrait;
  String? avance;
  String? reste;
  Client? client;
  String? status;
  DateTime? createdAt;

  Reservation({
    this.montant,
    this.dateRetrait,
    this.avance,
    this.reste,
    this.client,
    this.status,
    this.createdAt,
  });

  Reservation.fromJson(Json json) {
    id = json['id'];
    montant = json['montant'];
    dateRetrait = json['dateRetrait'].toString().toDateTime();
    avance = json['avance'];
    reste = json['reste'];
    if (json['client'] != null) {
      client = Client.fromJson(json['client']);
    }
    status = json['status'];
    createdAt = json['createdAt'].toString().toDateTime();
  }

  @override
  Reservation fromJson(Json json) => Reservation.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'dateRetrait': dateRetrait?.toIso8601String(),
      'avance': avance,
      'reste': reste,
      'client': client?.toJson(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

// Vente
class VenteItem extends ModelJson {
  int? quantite;
  String? montant;
  PaiementBoutiqueDetail? paiementBoutique;

  VenteItem({this.quantite, this.montant, this.paiementBoutique});

  VenteItem.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    montant = json['montant'];
    if (json['paiementBoutique'] != null) {
      paiementBoutique =
          PaiementBoutiqueDetail.fromJson(json['paiementBoutique']);
    }
  }

  @override
  VenteItem fromJson(Json json) => VenteItem.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantite': quantite,
      'montant': montant,
      'paiementBoutique': paiementBoutique?.toJson(),
    };
  }
}

class PaiementBoutiqueDetail extends ModelJson {
  int? quantite;
  Client? client;
  String? montant;
  String? reference;
  String? type;
  DateTime? createdAt;

  PaiementBoutiqueDetail({
    this.quantite,
    this.client,
    this.montant,
    this.reference,
    this.type,
    this.createdAt,
  });

  PaiementBoutiqueDetail.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    if (json['client'] != null) {
      client = Client.fromJson(json['client']);
    }
    montant = json['montant'];
    reference = json['reference'];
    type = json['type'];
    createdAt = json['createdAt'].toString().toDateTime();
  }

  @override
  PaiementBoutiqueDetail fromJson(Json json) =>
      PaiementBoutiqueDetail.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantite': quantite,
      'client': client?.toJson(),
      'montant': montant,
      'reference': reference,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
