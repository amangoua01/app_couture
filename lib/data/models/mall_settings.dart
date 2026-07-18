class MallSettings {
  String libelle;
  String description;
  String email;
  String numero;

  // Promotions header
  String mallPromoHeaderBadge;
  String mallPromoHeaderTitle;
  String mallPromoHeaderSubtitle;
  String mallPromoHeaderDescription;

  // Nouveautés header
  String mallNouveauHeaderBadge;
  String mallNouveauHeaderTitle;
  String mallNouveauHeaderSubtitle;
  String mallNouveauHeaderDescription;

  // Réseaux sociaux
  String whatsapp;
  String facebook;
  String instagram;
  String tiktok;
  String twitter;
  String youtube;

  MallSettings({
    this.libelle = '',
    this.description = '',
    this.email = '',
    this.numero = '',
    this.mallPromoHeaderBadge = '',
    this.mallPromoHeaderTitle = '',
    this.mallPromoHeaderSubtitle = '',
    this.mallPromoHeaderDescription = '',
    this.mallNouveauHeaderBadge = '',
    this.mallNouveauHeaderTitle = '',
    this.mallNouveauHeaderSubtitle = '',
    this.mallNouveauHeaderDescription = '',
    this.whatsapp = '',
    this.facebook = '',
    this.instagram = '',
    this.tiktok = '',
    this.twitter = '',
    this.youtube = '',
  });

  factory MallSettings.fromJson(Map<String, dynamic> json) => MallSettings(
        libelle: json['libelle'] ?? '',
        description: json['description'] ?? '',
        email: json['email'] ?? '',
        numero: json['numero'] ?? '',
        mallPromoHeaderBadge: json['mallPromoHeaderBadge'] ?? '',
        mallPromoHeaderTitle: json['mallPromoHeaderTitle'] ?? '',
        mallPromoHeaderSubtitle: json['mallPromoHeaderSubtitle'] ?? '',
        mallPromoHeaderDescription: json['mallPromoHeaderDescription'] ?? '',
        mallNouveauHeaderBadge: json['mallNouveauHeaderBadge'] ?? '',
        mallNouveauHeaderTitle: json['mallNouveauHeaderTitle'] ?? '',
        mallNouveauHeaderSubtitle: json['mallNouveauHeaderSubtitle'] ?? '',
        mallNouveauHeaderDescription: json['mallNouveauHeaderDescription'] ?? '',
        whatsapp: json['whatsapp'] ?? '',
        facebook: json['facebook'] ?? '',
        instagram: json['instagram'] ?? '',
        tiktok: json['tiktok'] ?? '',
        twitter: json['twitter'] ?? '',
        youtube: json['youtube'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'libelle': libelle,
        'description': description,
        'email': email,
        'numero': numero,
        'mallPromoHeaderBadge': mallPromoHeaderBadge,
        'mallPromoHeaderTitle': mallPromoHeaderTitle,
        'mallPromoHeaderSubtitle': mallPromoHeaderSubtitle,
        'mallPromoHeaderDescription': mallPromoHeaderDescription,
        'mallNouveauHeaderBadge': mallNouveauHeaderBadge,
        'mallNouveauHeaderTitle': mallNouveauHeaderTitle,
        'mallNouveauHeaderSubtitle': mallNouveauHeaderSubtitle,
        'mallNouveauHeaderDescription': mallNouveauHeaderDescription,
        'whatsapp': whatsapp,
        'facebook': facebook,
        'instagram': instagram,
        'tiktok': tiktok,
        'twitter': twitter,
        'youtube': youtube,
      };
}
