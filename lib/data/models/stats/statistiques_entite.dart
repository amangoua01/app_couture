import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/stats/dash_activites.dart';
import 'package:ateliya/data/models/stats/dernieres_transactions.dart';
import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/data/models/stats/periode.dart';
import 'package:ateliya/data/models/stats/revenus_par_type.dart';
import 'package:ateliya/data/models/stats/revenus_quotidiens.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class StatistiquesEntite extends ModelJson {
  int? entityId;
  String? entityNom;
  String? entityType;
  Periode? periode;
  Kpis? kpis;
  List<RevenusQuotidiens> revenusQuotidiens = const [];
  List<RevenusParType> revenusParType = const [];
  List<DashActivites> activites = const [];
  List<DernieresTransactions> dernieresTransactions = const [];

  StatistiquesEntite({
    this.entityId,
    this.entityNom,
    this.entityType,
    this.periode,
    this.kpis,
    this.revenusQuotidiens = const [],
    this.revenusParType = const [],
    this.activites = const [],
    this.dernieresTransactions = const [],
  });

  @override
  StatistiquesEntite fromJson(Json json) {
    return StatistiquesEntite.fromJson(json);
  }

  StatistiquesEntite.fromJson(Json json) {
    entityId = json['entity_id'];
    entityNom = json['entity_nom'];
    entityType = json['entity_type'];
    periode =
        json['periode'] != null ? Periode.fromJson(json['periode']) : null;
    kpis = json['kpis'] != null ? Kpis.fromJson(json['kpis']) : null;

    if (json['revenusQuotidiens'] != null) {
      revenusQuotidiens = <RevenusQuotidiens>[];
      json['revenusQuotidiens'].forEach((v) {
        revenusQuotidiens.add(RevenusQuotidiens.fromJson(v));
      });
    }

    if (json['revenusParType'] != null) {
      revenusParType = <RevenusParType>[];
      json['revenusParType'].forEach((v) {
        revenusParType.add(RevenusParType.fromJson(v));
      });
    }

    if (json['activites'] != null) {
      activites = <DashActivites>[];
      json['activites'].forEach((v) {
        activites.add(DashActivites.fromJson(v));
      });
    }

    if (json['dernieresTransactions'] != null) {
      dernieresTransactions = <DernieresTransactions>[];
      json['dernieresTransactions'].forEach((v) {
        dernieresTransactions.add(DernieresTransactions.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['entity_id'] = entityId;
    data['entity_nom'] = entityNom;
    data['entity_type'] = entityType;

    if (periode != null) {
      data['periode'] = periode!.toJson();
    }
    if (kpis != null) {
      data['kpis'] = kpis!.toJson();
    }
    data['revenusQuotidiens'] =
        revenusQuotidiens.map((v) => v.toJson()).toList();
    data['revenusParType'] = revenusParType.map((v) => v.toJson()).toList();
    data['activites'] = activites.map((v) => v.toJson()).toList();
    data['dernieresTransactions'] =
        dernieresTransactions.map((v) => v.toJson()).toList();

    return data;
  }
}
