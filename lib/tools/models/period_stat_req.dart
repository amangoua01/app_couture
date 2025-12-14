import 'package:ateliya/tools/constants/period_stat.dart';

class PeriodStatReq {
  DateTime? dateDebut;
  DateTime? dateFin;
  PeriodStat filtre = PeriodStat.jour;

  PeriodStatReq({
    this.dateDebut,
    this.dateFin,
    this.filtre = PeriodStat.jour,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    switch (filtre) {
      case PeriodStat.jour || PeriodStat.mois:
        final now = DateTime.now();
        data['valeur'] = "${now.year}-${now.month}";
        data['dateDebut'] = null;
        data['dateFin'] = null;
        break;
      case PeriodStat.annee:
        data['valeur'] = DateTime.now().year;
        break;
      case PeriodStat.periode:
        data['dateDebut'] = dateDebut?.toIso8601String();
        data['dateFin'] = dateFin?.toIso8601String();
    }
    data['filtre'] = filtre.code;
    return data;
  }
}
