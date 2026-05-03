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
    final targetDate = dateDebut ?? DateTime.now();

    switch (filtre) {
      case PeriodStat.jour:
        data['filtre'] = "jour";
        data['dateDebut'] = targetDate.toIso8601String().split('T')[0];
        data['dateFin'] = (dateFin ?? targetDate).toIso8601String().split('T')[0];
        data['valeur'] = null;
        break;
      case PeriodStat.mois:
        data['filtre'] = "mois";
        data['dateDebut'] = null;
        data['dateFin'] = null;
        data['valeur'] = "${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}";
        break;
      case PeriodStat.annee:
        data['filtre'] = "annee";
        data['dateDebut'] = null;
        data['dateFin'] = null;
        data['valeur'] = "${targetDate.year}";
        break;
      case PeriodStat.periode:
        data['filtre'] = "periode";
        data['dateDebut'] = dateDebut?.toIso8601String().split('T')[0];
        data['dateFin'] = dateFin?.toIso8601String().split('T')[0];
        data['valeur'] = null;
        break;
    }

    return data;
  }
}
