class StatPeriode {
  String? debut;
  String? fin;
  int? nbJours;
  String? filtre;

  StatPeriode({this.debut, this.fin, this.nbJours, this.filtre});

  StatPeriode.fromJson(Map<String, dynamic> json) {
    debut = json['debut'];
    fin = json['fin'];
    nbJours = json['nbJours'];
    filtre = json['filtre'];
  }

  Map<String, dynamic> toJson() => {
        'debut': debut,
        'fin': fin,
        'nbJours': nbJours,
        'filtre': filtre,
      };
}
