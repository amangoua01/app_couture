import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/ligne_entres.dart';
import 'package:ateliya/data/models/ligne_reservations.dart';
import 'package:ateliya/data/models/modele.dart';
import 'package:ateliya/data/models/paiement_boutique_lignes.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/detail_model_filter_vente.dart';
import 'package:ateliya/tools/models/detail_modele_entre_stock.dart';

class ModeleBoutique extends ModelJson<ModeleBoutique> {
  int? quantite;
  String? prix;
  double? prixMinimal;
  Modele? modele;
  List<LigneEntres> _ligneEntres = [];
  List<LigneReservations> _ligneReservations = [];
  List<PaiementBoutiqueLignes> _paiementBoutiqueLignes = [];
  String? taille;
  String? createdAt;
  bool? isActive;
  Boutique? boutique;
  User? creator;
  int? color;

  ModeleBoutique({
    this.quantite,
    this.prix,
    this.prixMinimal,
    this.modele,
    List<LigneEntres> ligneEntres = const [],
    List<LigneReservations> ligneReservations = const [],
    List<PaiementBoutiqueLignes> paiementBoutiqueLignes = const [],
    this.taille,
    this.createdAt,
    this.isActive,
    this.boutique,
    this.color,
  })  : _ligneEntres = ligneEntres,
        _ligneReservations = ligneReservations,
        _paiementBoutiqueLignes = paiementBoutiqueLignes;

  @override
  ModeleBoutique fromJson(Json json) {
    return ModeleBoutique.fromJson(json);
  }

  ModeleBoutique.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    prix = json['prix'];
    prixMinimal = json['prixMinimal'].toString().toDouble();
    modele = json['modele'] != null ? Modele.fromJson(json['modele']) : null;
    if (json['ligneEntres'] != null) {
      _ligneEntres = <LigneEntres>[];
      json['ligneEntres'].forEach((v) {
        _ligneEntres.add(LigneEntres.fromJson(v));
      });
    }
    if (json['ligneReservations'] != null) {
      _ligneReservations = <LigneReservations>[];
      json['ligneReservations'].forEach((v) {
        _ligneReservations.add(LigneReservations.fromJson(v));
      });
    }
    if (json['paiementBoutiqueLignes'] != null) {
      _paiementBoutiqueLignes = <PaiementBoutiqueLignes>[];
      json['paiementBoutiqueLignes'].forEach((v) {
        _paiementBoutiqueLignes.add(PaiementBoutiqueLignes.fromJson(v));
      });
    }
    taille = json['taille'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    boutique =
        json['boutique'] != null ? Boutique.fromJson(json['boutique']) : null;
    creator =
        json['createdBy'] != null ? User.fromJson(json['createdBy']) : null;
    color = json['couleur'].toString().toInt();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantite'] = quantite;
    data['modele'] = modele?.id;
    data['boutique'] = boutique?.id;
    data['prix'] = prix;
    data['prixMinimal'] = prixMinimal;
    data['taille'] = taille;
    data['color'] = color;
    return data;
  }

  List<Client> get clients {
    final clientsSet = <Client>{};
    for (var paiementLigne in _paiementBoutiqueLignes) {
      final client = paiementLigne.paiementBoutique?.client;
      if (client != null) {
        if (!clientsSet.any((e) => e.id == client.id)) {
          clientsSet.add(client);
        }
      }
    }
    return clientsSet.toList();
  }

  List<User> get operateurs {
    final vendeursSet = <User>{};
    for (var entree in _ligneEntres) {
      final vendeur = entree.entreStock?.creator;
      if (vendeur != null) {
        if (!vendeursSet.any((e) => e.id == vendeur.id)) {
          vendeursSet.add(vendeur);
        }
      }
    }
    return vendeursSet.toList();
  }

  List<LigneEntres> ligneEntres(DetailModeleEntreStock? filter) {
    if (filter != null && !filter.isEmpty()) {
      if (filter.dateDebut.dateTime != null) {
        _ligneEntres = _ligneEntres
            .where(
              (e) =>
                  e.entreStock != null &&
                  e.entreStock!.date != null &&
                  e.entreStock!.date!
                          .toDateTime()
                          ?.isAfter(filter.dateDebut.dateTime!) ==
                      true,
            )
            .toList();
      }
      if (filter.dateFin.dateTime != null) {}
      _ligneEntres = _ligneEntres
          .where(
            (e) =>
                e.entreStock != null &&
                e.entreStock!.date != null &&
                e.entreStock!.date!
                        .toDateTime()
                        ?.isBefore(filter.dateFin.dateTime!) ==
                    true,
          )
          .toList();
      if (filter.operateur != null) {
        _ligneEntres = _ligneEntres
            .where((e) =>
                e.entreStock != null &&
                e.entreStock!.creator != null &&
                e.entreStock!.creator!.id == filter.operateur!.id)
            .toList();
      }
    }
    return _ligneEntres;
  }

  List<LigneReservations> ligneReservations(DetailModelFilterVente? filter) {
    if (filter != null && !filter.isEmpty()) {
      if (filter.dateDebut.dateTime != null) {
        _ligneReservations = _ligneReservations
            .where(
              (e) =>
                  e.reservation != null &&
                  e.reservation!.createdAt != null &&
                  e.reservation!.createdAt!
                          .toDateTime()
                          ?.isAfter(filter.dateDebut.dateTime!) ==
                      true,
            )
            .toList();
      }
      if (filter.dateFin.dateTime != null) {
        _ligneReservations = _ligneReservations
            .where(
              (e) =>
                  e.reservation != null &&
                  e.reservation!.createdAt != null &&
                  e.reservation!.createdAt!
                          .toDateTime()
                          ?.isBefore(filter.dateFin.dateTime!) ==
                      true,
            )
            .toList();
      }
      if (filter.client != null) {
        _ligneReservations = _ligneReservations
            .where((e) =>
                e.reservation != null &&
                e.reservation!.client != null &&
                e.reservation!.client!.id == filter.client!.id)
            .toList();
      }
    }
    return _ligneReservations;
  }

  List<PaiementBoutiqueLignes> paiementBoutiqueLignes(
      DetailModelFilterVente? filter) {
    if (filter != null && !filter.isEmpty()) {
      if (filter.dateDebut.dateTime != null) {
        _paiementBoutiqueLignes = _paiementBoutiqueLignes
            .where(
              (e) =>
                  e.paiementBoutique != null &&
                  e.paiementBoutique!.createdAt != null &&
                  e.paiementBoutique!.createdAt!
                          .toDateTime()
                          ?.isAfter(filter.dateDebut.dateTime!) ==
                      true,
            )
            .toList();
      }
      if (filter.dateFin.dateTime != null) {
        _paiementBoutiqueLignes = _paiementBoutiqueLignes
            .where(
              (e) =>
                  e.paiementBoutique != null &&
                  e.paiementBoutique!.createdAt != null &&
                  e.paiementBoutique!.createdAt!
                          .toDateTime()
                          ?.isBefore(filter.dateFin.dateTime!) ==
                      true,
            )
            .toList();
      }
      if (filter.client != null) {
        _paiementBoutiqueLignes = _paiementBoutiqueLignes
            .where((e) =>
                e.paiementBoutique != null &&
                e.paiementBoutique!.client != null &&
                e.paiementBoutique!.client!.id == filter.client!.id)
            .toList();
      }
    }
    return _paiementBoutiqueLignes;
  }
}
