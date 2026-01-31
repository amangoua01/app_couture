class TransactionSummary {
  final double revenus;
  final double depenses;
  final double total;
  final String currency;

  TransactionSummary({
    required this.revenus,
    required this.depenses,
    required this.total,
    required this.currency,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      revenus: (json['revenus'] as num).toDouble(),
      depenses: (json['depenses'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      currency: json['currency'],
    );
  }
}

class TransactionItem {
  final int id;
  final String type;
  final String description;
  final double montant;
  final String montantFormate;
  final bool isRevenu;
  final String heure;
  final String date;
  final String reference;
  final String? moyenPaiement;

  TransactionItem({
    required this.id,
    required this.type,
    required this.description,
    required this.montant,
    required this.montantFormate,
    required this.isRevenu,
    required this.heure,
    required this.date,
    required this.reference,
    this.moyenPaiement,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      montant: (json['montant'] as num).toDouble(),
      montantFormate: json['montantFormate'],
      isRevenu: json['isRevenu'],
      heure: json['heure'],
      date: json['date'],
      reference: json['reference'],
      moyenPaiement: json['moyenPaiement'],
    );
  }
}

class TransactionResponse {
  final TransactionSummary summary;
  final List<TransactionItem> transactions;

  TransactionResponse({
    required this.summary,
    required this.transactions,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      summary: TransactionSummary.fromJson(json['summary']),
      transactions: (json['transactions'] as List)
          .map((e) => TransactionItem.fromJson(e))
          .toList(),
    );
  }
}
