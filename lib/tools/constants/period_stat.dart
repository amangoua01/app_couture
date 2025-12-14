enum PeriodStat {
  jour("Aujourd'hui", "jour"),
  mois("Ce mois", "mois"),
  annee("Cette année", "annee"),
  periode("Période", "periode");

  final String libelle, code;

  const PeriodStat(this.libelle, this.code);
}
