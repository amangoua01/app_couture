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

class MallPromotionNouveau {
  final int id;
  final bool isPromotion;
  final bool isNouveau;
  final String? prixPromotion;
  final String? prixUnite;
  final String? prixNouveau;
  final String? dateFinPromotion;
  final int? quantite;
  final bool isActive;
  final FichierServer? image;

  MallPromotionNouveau({
    required this.id,
    this.isPromotion = false,
    this.isNouveau = false,
    this.prixPromotion,
    this.prixUnite,
    this.prixNouveau,
    this.dateFinPromotion,
    this.quantite,
    this.isActive = true,
    this.image,
  });

  factory MallPromotionNouveau.fromJson(Map<String, dynamic> json) =>
      MallPromotionNouveau(
        id: json['id'] ?? 0,
        isPromotion: json['isPromotion'] == true,
        isNouveau: json['isNouveau'] == true,
        prixPromotion: json['prixPromotion']?.toString(),
        prixUnite: json['prixUnite']?.toString(),
        prixNouveau: json['prixNouveau']?.toString(),
        dateFinPromotion: json['dateFinPromotion'],
        quantite: json['quantite'],
        isActive: json['isActive'] == true,
        image: json['image'] != null
            ? FichierServer.fromJson(json['image'])
            : null,
      );
}

class MallModeleBoutique {
  final int id;
  final String prix;
  final MallModeleInfo? modele;
  final MallBoutiqueInfo? boutique;
  final bool isActive;
  final bool? isSurMesure;
  final List<MallPromotionNouveau> promotionNouveaus;

  bool get isNouveaute => promotionNouveaus.any((e) => e.isNouveau && e.isActive);
  bool get isPromotion => promotionNouveaus.any((e) => e.isPromotion && e.isActive);

  MallPromotionNouveau? get activePromo =>
      promotionNouveaus.where((e) => e.isPromotion && e.isActive).firstOrNull;

  MallPromotionNouveau? get activeNouveau =>
      promotionNouveaus.where((e) => e.isNouveau && e.isActive).firstOrNull;

  MallModeleBoutique({
    required this.id,
    required this.prix,
    this.modele,
    this.boutique,
    required this.isActive,
    this.isSurMesure,
    this.promotionNouveaus = const [],
  });

  factory MallModeleBoutique.fromJson(Map<String, dynamic> json) =>
      MallModeleBoutique(
        id: json['id'],
        prix: json['prix'] ?? '0',
        modele: json['modele'] != null
            ? MallModeleInfo.fromJson(json['modele'])
            : null,
        boutique: json['boutique'] != null
            ? MallBoutiqueInfo.fromJson(json['boutique'])
            : null,
        isActive: json['isActive'] ?? true,
        isSurMesure: json['isSurMesure'],
        promotionNouveaus: (json['modeleBoutiquePromotionNouveaus'] as List? ?? [])
            .map((e) => MallPromotionNouveau.fromJson(e))
            .toList(),
      );
}
