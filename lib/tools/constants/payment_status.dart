enum PaymentStatus {
  pending("En attente"),
  success("Validé"),
  failed("Annulé");

  final String libelle;

  const PaymentStatus(this.libelle);
}
