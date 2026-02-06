enum PeriodeVenteEnum {
  tous("Tous", "tous"),
  aujourdhui("Aujourd'hui", "aujourd_hui"),
  septJours("7 derniers jours", "7_derniers_jours");

  final String label, code;
  const PeriodeVenteEnum(this.label, this.code);
}
