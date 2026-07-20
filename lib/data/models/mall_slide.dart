import 'package:ateliya/data/models/fichier_server.dart';

class MallSlide {
  final int id;
  final String title;
  final String? subtitle;
  final String? description;
  final FichierServer? image;
  final String? gradient;
  final String? badgeText;
  final int? price;

  MallSlide({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.image,
    this.gradient,
    this.badgeText,
    this.price,
  });

  factory MallSlide.fromJson(Map<String, dynamic> json) => MallSlide(
        id: json['id'],
        title: json['title'] ?? '',
        subtitle: json['subtitle'],
        description: json['description'],
        image: json['image'] != null ? FichierServer.fromJson(json['image']) : null,
        gradient: json['gradient'],
        badgeText: json['badgeText'],
        price: json['price'],
      );
}
