enum CommandeStatus {
  livre("livre", "Livré"),
  nonLivre(null, "Non livré"),
  reporte("reporte", "Reporté"),
  annule("annule", "Annulé");

  final String? code;
  final String libelle;

  const CommandeStatus(this.code, this.libelle);
}
