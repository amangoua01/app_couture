import 'package:ateliya/data/models/fichier_server.dart';

class MallFavoriModele {
  final int id;
  final String libelle;
  final FichierServer? photo;

  MallFavoriModele({required this.id, required this.libelle, this.photo});

  factory MallFavoriModele.fromJson(Map<String, dynamic> json) =>
      MallFavoriModele(
        id: json['id'],
        libelle: json['libelle'] ?? '',
        photo: json['photo'] != null
            ? FichierServer.fromJson(json['photo'])
            : null,
      );
}

class MallFavoriBoutique {
  final int id;
  final String libelle;
  final String situation;

  MallFavoriBoutique(
      {required this.id, required this.libelle, required this.situation});

  factory MallFavoriBoutique.fromJson(Map<String, dynamic> json) =>
      MallFavoriBoutique(
        id: json['id'],
        libelle: json['libelle'] ?? '',
        situation: json['situation'] ?? '',
      );
}

class MallFavoriModeleBoutique {
  final int id;
  final String prix;
  final MallFavoriModele? modele;
  final MallFavoriBoutique? boutique;

  MallFavoriModeleBoutique(
      {required this.id,
      required this.prix,
      this.modele,
      this.boutique});

  factory MallFavoriModeleBoutique.fromJson(Map<String, dynamic> json) =>
      MallFavoriModeleBoutique(
        id: json['id'],
        prix: json['prix'] ?? '0',
        modele: json['modele'] != null
            ? MallFavoriModele.fromJson(json['modele'])
            : null,
        boutique: json['boutique'] != null
            ? MallFavoriBoutique.fromJson(json['boutique'])
            : null,
      );
}

class MallFavori {
  final int id;
  final String dateAjout;
  final MallFavoriModeleBoutique? modeleBoutique;

  MallFavori(
      {required this.id, required this.dateAjout, this.modeleBoutique});

  factory MallFavori.fromJson(Map<String, dynamic> json) => MallFavori(
        id: json['id'],
        dateAjout: json['dateAjout'] ?? '',
        modeleBoutique: json['modeleBoutique'] != null
            ? MallFavoriModeleBoutique.fromJson(json['modeleBoutique'])
            : null,
      );
}
