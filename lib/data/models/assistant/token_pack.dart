/// Pack de tokens proposé à l'achat.
class TokenPack {
  final int id;
  final String libelle;
  final int tokens;
  final int montant;
  final int messages;

  const TokenPack({
    required this.id,
    required this.libelle,
    required this.tokens,
    required this.montant,
    required this.messages,
  });

  factory TokenPack.fromJson(Map<String, dynamic> json) {
    int n(String key) => (json[key] as num?)?.toInt() ?? 0;
    return TokenPack(
      id: json['id'] as int,
      libelle: (json['libelle'] ?? '').toString(),
      tokens: n('tokens'),
      montant: n('montant'),
      messages: n('messages'),
    );
  }
}

/// Paiement de pack lancé : à ouvrir dans le navigateur, puis à suivre.
class TokenPurchase {
  final String reference;
  final String redirectUrl;

  const TokenPurchase({required this.reference, required this.redirectUrl});

  factory TokenPurchase.fromJson(Map<String, dynamic> json) {
    return TokenPurchase(
      reference: (json['reference'] ?? '').toString(),
      redirectUrl: (json['redirectUrl'] ?? '').toString(),
    );
  }
}
