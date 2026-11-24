class AssistantConversation {
  final int id;
  final String titre;
  final DateTime? misAJourLe;

  const AssistantConversation({
    required this.id,
    required this.titre,
    this.misAJourLe,
  });

  factory AssistantConversation.fromJson(Map<String, dynamic> json) {
    return AssistantConversation(
      id: json['id'] as int,
      titre: (json['titre'] ?? 'Conversation').toString(),
      misAJourLe: DateTime.tryParse((json['misAJourLe'] ?? '').toString()),
    );
  }
}
