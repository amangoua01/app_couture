import 'package:ateliya/data/models/abonnement.dart';
import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/data/models/settings.dart';
import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/data/models/vente.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class AccueilData extends ModelJson {
  double caisse = 0;
  double depenses = 0;
  Settings? settings;
  List<Abonnement> abonnements = [];
  List<Mesure> commandes = [];
  List<Vente> meilleuresVentes = [];

  Kpis get kpis => Kpis(
        clientsActifs: settings?.nombreUser ?? 0,
        commandesEnCours: commandes.where((e) => e.isActive).length,
        chiffreAffaires: 0,
        reservationsActives: 0,
      );

  AccueilData({
    this.caisse = 0,
    this.depenses = 0,
    this.settings,
    this.abonnements = const [],
    this.commandes = const [],
    this.meilleuresVentes = const [],
  });

  AccueilData.fromJson(Json json) {
    caisse = json["caisse"].toString().toDouble().value;
    depenses = json["depenses"].toString().toDouble().value;
    if (json["settings"] != null) {
      settings = Settings.fromJson(json["settings"]);
    }
    if (json["abonnements"] != null) {
      abonnements = (json["abonnements"] as List)
          .map((e) => Abonnement.fromJson(e))
          .toList();
    }
    if (json["commandes"] != null) {
      commandes =
          (json["commandes"] as List).map((e) => Mesure.fromJson(e)).toList();
    }
    if (json["meilleuresVentes"] != null) {
      meilleuresVentes = (json["meilleuresVentes"] as List)
          .map((e) => Vente.fromJson(e))
          .toList();
    }
  }

  @override
  AccueilData fromJson(Json json) => AccueilData.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "caisse": caisse,
        "depenses": depenses,
        "settings": settings?.toJson(),
        "abonnements": abonnements.map((e) => e.toJson()).toList(),
        "commandes": commandes.map((e) => e.toJson()).toList(),
        "meilleuresVentes": meilleuresVentes.map((e) => e.toJson()).toList(),
      };
}
