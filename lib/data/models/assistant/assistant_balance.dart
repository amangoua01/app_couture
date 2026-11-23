/// Solde de tokens de l'entreprise et règles de consommation.
class AssistantBalance {
  final int soldeForfait;
  final int soldePacks;
  final int soldeTotal;
  final int quotaMensuel;
  final int coutParMessage;
  final DateTime? prochainRenouvellement;

  const AssistantBalance({
    this.soldeForfait = 0,
    this.soldePacks = 0,
    this.soldeTotal = 0,
    this.quotaMensuel = 0,
    this.coutParMessage = 10,
    this.prochainRenouvellement,
  });

  /// Nombre de messages que le solde permet encore d'envoyer.
  int get messagesRestants =>
      coutParMessage > 0 ? soldeTotal ~/ coutParMessage : 0;

  AssistantBalance copyWithTotals({
    required int soldeForfait,
    required int soldePacks,
  }) {
    return AssistantBalance(
      soldeForfait: soldeForfait,
      soldePacks: soldePacks,
      soldeTotal: soldeForfait + soldePacks,
      quotaMensuel: quotaMensuel,
      coutParMessage: coutParMessage,
      prochainRenouvellement: prochainRenouvellement,
    );
  }

  factory AssistantBalance.fromJson(Map<String, dynamic> json) {
    int n(String key) => (json[key] as num?)?.toInt() ?? 0;
    return AssistantBalance(
      soldeForfait: n('soldeForfait'),
      soldePacks: n('soldePacks'),
      soldeTotal: n('soldeTotal'),
      quotaMensuel: n('quotaMensuel'),
      coutParMessage: n('coutParMessage') == 0 ? 10 : n('coutParMessage'),
      prochainRenouvellement: DateTime.tryParse(
        (json['prochainRenouvellement'] ?? '').toString(),
      ),
    );
  }
}
