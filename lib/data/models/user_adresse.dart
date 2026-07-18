class UserAdresse {
  final int id;
  final String uuid;
  String titre;
  String adresse;
  String ville;
  String telephone;
  bool isDefault;
  bool isActive;

  UserAdresse({
    required this.id,
    required this.uuid,
    required this.titre,
    required this.adresse,
    required this.ville,
    required this.telephone,
    required this.isDefault,
    required this.isActive,
  });

  factory UserAdresse.fromJson(Map<String, dynamic> json) => UserAdresse(
        id: json['id'],
        uuid: json['uuid'] ?? '',
        titre: json['titre'] ?? '',
        adresse: json['adresse'] ?? '',
        ville: json['ville'] ?? '',
        telephone: json['telephone'] ?? '',
        isDefault: json['isDefault'] ?? false,
        isActive: json['isActive'] ?? true,
      );
}
