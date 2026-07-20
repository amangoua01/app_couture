import 'package:ateliya/data/models/fichier_server.dart';

class MallModeleInfo {
  final int id;
  final String libelle;
  final FichierServer? photo;

  MallModeleInfo({required this.id, required this.libelle, this.photo});

  factory MallModeleInfo.fromJson(Map<String, dynamic> json) => MallModeleInfo(
        id: json['id'],
        libelle: json['libelle'] ?? '',
        photo: json['photo'] != null ? FichierServer.fromJson(json['photo']) : null,
      );
}

class MallBoutiqueInfo {
  final int id;
  final String libelle;
  final String situation;

  MallBoutiqueInfo({required this.id, required this.libelle, required this.situation});

  factory MallBoutiqueInfo.fromJson(Map<String, dynamic> json) => MallBoutiqueInfo(
        id: json['id'],
        libelle: json['libelle'] ?? '',
        situation: json['situation'] ?? '',
      );
}

class MallModeleBoutique {
  final int id;
  final String prix;
  final MallModeleInfo? modele;
  final MallBoutiqueInfo? boutique;
  final bool isActive;
  final bool? isSurMesure;
  final List<dynamic> promotionNouveaus;

  bool get isNouveaute => promotionNouveaus.any((e) => e['isNouveau'] == true);
  bool get isPromotion => promotionNouveaus.any((e) => e['isPromotion'] == true);

  MallModeleBoutique({
    required this.id,
    required this.prix,
    this.modele,
    this.boutique,
    required this.isActive,
    this.isSurMesure,
    this.promotionNouveaus = const [],
  });

  factory MallModeleBoutique.fromJson(Map<String, dynamic> json) => MallModeleBoutique(
        id: json['id'],
        prix: json['prix'] ?? '0',
        modele: json['modele'] != null ? MallModeleInfo.fromJson(json['modele']) : null,
        boutique: json['boutique'] != null ? MallBoutiqueInfo.fromJson(json['boutique']) : null,
        isActive: json['isActive'] ?? true,
        isSurMesure: json['isSurMesure'],
        promotionNouveaus: json['modeleBoutiquePromotionNouveaus'] ?? [],
      );
}
