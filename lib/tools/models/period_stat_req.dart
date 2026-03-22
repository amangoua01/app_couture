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
    final now = DateTime.now();

    switch (filtre) {
      case PeriodStat.jour:
        data['filtre'] = "journalier";
        data['valeur'] = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        break;
      case PeriodStat.mois:
        data['filtre'] = "mensuel";
        data['valeur'] = "${now.year}-${now.month.toString().padLeft(2, '0')}";
        break;
      case PeriodStat.annee:
        data['filtre'] = "annuel";
        data['valeur'] = "${now.year}";
        break;
      case PeriodStat.periode:
        data['filtre'] = "periode";
        data['dateDebut'] = dateDebut?.toIso8601String().split('T')[0];
        data['dateFin'] = dateFin?.toIso8601String().split('T')[0];
        break;
    }
    
    // Pour "mensuel" ou "journalier", on peut aussi envoyer les dates si nécessaire par l'API
    if (filtre != PeriodStat.periode) {
       data['dateDebut'] = null;
       data['dateFin'] = null;
    }

    return data;
  }
}
