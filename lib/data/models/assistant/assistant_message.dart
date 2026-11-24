/// Mesures d'une réponse de Sika : où est parti le temps.
class AssistantMeta {
  final int totalMs;
  final int modeleMs;
  final int outilsMs;
  final String agent;
  final int appelsAuModele;

  const AssistantMeta({
    required this.totalMs,
    required this.modeleMs,
    required this.outilsMs,
    required this.agent,
    required this.appelsAuModele,
  });

  factory AssistantMeta.fromJson(Map<String, dynamic> json) {
    int n(String key) => (json[key] as num?)?.toInt() ?? 0;
    return AssistantMeta(
      totalMs: n('totalMs'),
      modeleMs: n('modeleMs'),
      outilsMs: n('outilsMs'),
      agent: (json['agent'] ?? '').toString(),
      appelsAuModele: n('appelsAuModele'),
    );
  }
}

/// Un message de la conversation avec Sika.
class AssistantMessage {
  final int? id;
  final bool fromUser;
  final String contenu;
  final int tokensConsommes;

  /// Noms techniques des outils consultés pour répondre (ex. `get_stock_status`).
  final List<String> outils;

  /// Mesures de la réponse (seulement juste après l'envoi, pas dans l'historique).
  final AssistantMeta? meta;

  const AssistantMessage({
    this.id,
    required this.fromUser,
    required this.contenu,
    this.tokensConsommes = 0,
    this.outils = const [],
    this.meta,
  });

  factory AssistantMessage.fromJson(Map<String, dynamic> json) {
    return AssistantMessage(
      id: json['id'] as int?,
      fromUser: json['role'] == 'user',
      contenu: (json['contenu'] ?? '').toString(),
      tokensConsommes: (json['tokensConsommes'] as num?)?.toInt() ?? 0,
      outils: ((json['outils'] as List?) ?? const []).map((e) => e.toString()).toList(),
    );
  }
}
