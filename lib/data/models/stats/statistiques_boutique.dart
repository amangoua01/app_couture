import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/stats/activites_boutique.dart';
import 'package:ateliya/data/models/stats/dernieres_transactions.dart';
import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/data/models/stats/periode.dart';
import 'package:ateliya/data/models/stats/revenus_par_type.dart';
import 'package:ateliya/data/models/stats/revenus_quotidiens.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class StatistiquesBoutique extends ModelJson {
  Periode? periode;
  Kpis? kpis;
  List<RevenusQuotidiens> revenusQuotidiens = [];
  List<RevenusParType> revenusParType = [];
  List<ActivitesBoutique>? activitesBoutique;
  List<DernieresTransactions>? dernieresTransactions;
  int? boutiqueId;

  StatistiquesBoutique({
    this.periode,
    this.kpis,
    this.revenusQuotidiens = const [],
    this.revenusParType = const [],
    this.activitesBoutique,
    this.dernieresTransactions,
    this.boutiqueId,
  });

  @override
  StatistiquesBoutique fromJson(Json json) {
    return StatistiquesBoutique.fromJson(json);
  }

  StatistiquesBoutique.fromJson(Json json) {
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

    if (json['activitesBoutique'] != null) {
      activitesBoutique = <ActivitesBoutique>[];
      json['activitesBoutique'].forEach((v) {
        activitesBoutique!.add(ActivitesBoutique.fromJson(v));
      });
    }

    if (json['dernieresTransactions'] != null) {
      dernieresTransactions = <DernieresTransactions>[];
      json['dernieresTransactions'].forEach((v) {
        dernieresTransactions!.add(DernieresTransactions.fromJson(v));
      });
    }

    boutiqueId = json['boutique_id'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (periode != null) {
      data['periode'] = periode!.toJson();
    }
    if (kpis != null) {
      data['kpis'] = kpis!.toJson();
    }
    data['revenusQuotidiens'] =
        revenusQuotidiens.map((v) => v.toJson()).toList();
    data['revenusParType'] = revenusParType.map((v) => v.toJson()).toList();
    if (activitesBoutique != null) {
      data['activitesBoutique'] =
          activitesBoutique!.map((v) => v.toJson()).toList();
    }
    if (dernieresTransactions != null) {
      data['dernieresTransactions'] =
          dernieresTransactions!.map((v) => v.toJson()).toList();
    }
    data['boutique_id'] = boutiqueId;

    return data;
  }
}
