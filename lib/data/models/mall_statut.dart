import 'package:ateliya/tools/constants/env.dart';

class MallStatut {
  final int id;
  final String type;
  final String? contenu;
  final String? url;
  final int vues;
  final String? expiresAt;
  final String? createdAt;

  MallStatut({
    required this.id,
    required this.type,
    this.contenu,
    this.url,
    required this.vues,
    this.expiresAt,
    this.createdAt,
  });

  String? get fullUrl {
    if (url == null) return null;
    if (url!.startsWith('http')) return url;
    return '${Env.baseUrl.url}$url';
  }

  factory MallStatut.fromJson(Map<String, dynamic> json) => MallStatut(
        id: json['id'],
        type: json['type'] ?? 'TEXTE',
        contenu: json['contenu'],
        url: json['url'],
        vues: json['vues'] ?? 0,
        expiresAt: json['expiresAt'],
        createdAt: json['createdAt'],
      );
}
