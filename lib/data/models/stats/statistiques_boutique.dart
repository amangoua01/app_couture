import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/stats/activites_boutique.dart';
import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/data/models/stats/modele_stock_stat.dart';
import 'package:ateliya/data/models/stats/periode.dart';
import 'package:ateliya/data/models/stats/revenus_par_type.dart';
import 'package:ateliya/data/models/stats/revenus_quotidiens.dart';
import 'package:ateliya/data/models/stats/top_modele_vendu.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class StatistiquesBoutique extends ModelJson {
  int? entityId;
  String? entityNom;
  String? entityType;
  Periode? periode;
  Kpis kpis = Kpis();
  List<RevenusQuotidiens> revenusQuotidiens = [];
  List<RevenusParType> revenusParType = [];
  List<ActivitesBoutique>? activitesBoutique;
  List<ModeleStockStat>? topModelesEnStock;
  List<ModeleStockStat>? modelesStock;
  List<TopModeleVendu>? topModelesVendus;

  StatistiquesBoutique({
    this.entityId,
    this.entityNom,
    this.entityType,
    this.periode,
    Kpis? kpis,
    this.revenusQuotidiens = const [],
    this.revenusParType = const [],
    this.activitesBoutique,
    this.topModelesEnStock,
    this.modelesStock,
    this.topModelesVendus,
  }) : kpis = kpis ?? Kpis();

  @override
  StatistiquesBoutique fromJson(Json json) {
    return StatistiquesBoutique.fromJson(json);
  }

  StatistiquesBoutique.fromJson(Json json) {
    entityId = json['entity_id'] ?? json['boutique_id'];
    entityNom = json['entity_nom'];
    entityType = json['entity_type'];
    periode =
        json['periode'] != null ? Periode.fromJson(json['periode']) : null;
    kpis = json['kpis'] != null ? Kpis.fromJson(json['kpis']) : Kpis();

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

    if (json['activitesBoutique'] != null) {
      activitesBoutique = <ActivitesBoutique>[];
      json['activitesBoutique'].forEach((v) {
        activitesBoutique!.add(ActivitesBoutique.fromJson(v));
      });
    }

    if (json['topModelesEnStock'] != null) {
      topModelesEnStock = <ModeleStockStat>[];
      json['topModelesEnStock'].forEach((v) {
        topModelesEnStock!.add(ModeleStockStat.fromJson(v));
      });
    }

    if (json['modelesStock'] != null) {
      modelesStock = <ModeleStockStat>[];
      json['modelesStock'].forEach((v) {
        modelesStock!.add(ModeleStockStat.fromJson(v));
      });
    }

    if (json['topModelesVendus'] != null) {
      topModelesVendus = <TopModeleVendu>[];
      json['topModelesVendus'].forEach((v) {
        topModelesVendus!.add(TopModeleVendu.fromJson(v));
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
    data['kpis'] = kpis.toJson();
    data['revenusQuotidiens'] =
        revenusQuotidiens.map((v) => v.toJson()).toList();
    data['revenusParType'] = revenusParType.map((v) => v.toJson()).toList();
    if (activitesBoutique != null) {
      data['activitesBoutique'] =
          activitesBoutique!.map((v) => v.toJson()).toList();
    }
    if (topModelesEnStock != null) {
      data['topModelesEnStock'] =
          topModelesEnStock!.map((v) => v.toJson()).toList();
    }
    if (modelesStock != null) {
      data['modelesStock'] = modelesStock!.map((v) => v.toJson()).toList();
    }
    if (topModelesVendus != null) {
      data['topModelesVendus'] =
          topModelesVendus!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
