class MallDashboardStats {
  final int totalOrders;
  final int pendingOrders;
  final int totalRevenue;
  final List<MallRecentOrder> recentOrders;

  MallDashboardStats({
    this.totalOrders = 0,
    this.pendingOrders = 0,
    this.totalRevenue = 0,
    this.recentOrders = const [],
  });

  factory MallDashboardStats.fromJson(Map<String, dynamic> json) {
    return MallDashboardStats(
      totalOrders: json['totalOrders'] ?? 0,
      pendingOrders: json['pendingOrders'] ?? 0,
      totalRevenue: json['totalRevenue'] ?? 0,
      recentOrders: (json['recentOrders'] as List? ?? [])
          .map((e) => MallRecentOrder.fromJson(e))
          .toList(),
    );
  }
}

class MallLigneCommande {
  final int id;
  final int quantite;
  final String prixUnitaire;
  final String modeleLibelle;
  final String? modelePhotoPath;
  final String? modelePhotoAlt;
  final String boutiqueLibelle;

  MallLigneCommande({
    this.id = 0,
    this.quantite = 0,
    this.prixUnitaire = '',
    this.modeleLibelle = '',
    this.modelePhotoPath,
    this.modelePhotoAlt,
    this.boutiqueLibelle = '',
  });

  factory MallLigneCommande.fromJson(Map<String, dynamic> json) {
    final mb = json['modeleBoutique'] as Map<String, dynamic>? ?? {};
    final modele = mb['modele'] as Map<String, dynamic>? ?? {};
    final photo = modele['photo'] as Map<String, dynamic>?;
    final boutique = mb['boutique'] as Map<String, dynamic>? ?? {};
    return MallLigneCommande(
      id: json['id'] ?? 0,
      quantite: json['quantite'] ?? 0,
      prixUnitaire: json['prixUnitaire'] ?? '',
      modeleLibelle: modele['libelle'] ?? '',
      modelePhotoPath: photo?['path'],
      modelePhotoAlt: photo?['alt'],
      boutiqueLibelle: boutique['libelle'] ?? '',
    );
  }

  String? get photoUrl {
    if (modelePhotoPath != null && modelePhotoAlt != null) {
      return '$modelePhotoPath/$modelePhotoAlt';
    }
    return null;
  }

  int get total => (int.tryParse(prixUnitaire) ?? 0) * quantite;
}

class MallRecentOrder {
  final int id;
  final String uuid;
  final String dateCommande;
  final String statut;
  final String montantTotal;
  final String entrepriseLibelle;
  final String? entrepriseLogo;
  final String entrepriseNumero;
  final String entrepriseEmail;
  final List<MallLigneCommande> lignes;

  MallRecentOrder({
    this.id = 0,
    this.uuid = '',
    this.dateCommande = '',
    this.statut = '',
    this.montantTotal = '',
    this.entrepriseLibelle = '',
    this.entrepriseLogo,
    this.entrepriseNumero = '',
    this.entrepriseEmail = '',
    this.lignes = const [],
  });

  factory MallRecentOrder.fromJson(Map<String, dynamic> json) {
    final entreprise = json['entreprise'] as Map<String, dynamic>? ?? {};
    final logo = entreprise['logo'] as Map<String, dynamic>?;
    return MallRecentOrder(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      dateCommande: json['dateCommande'] ?? '',
      statut: json['statut'] ?? '',
      montantTotal: json['montantTotal'] ?? '',
      entrepriseLibelle: entreprise['libelle'] ?? '',
      entrepriseLogo: logo != null ? '${logo['path']}/${logo['alt']}' : null,
      entrepriseNumero: entreprise['numero'] ?? '',
      entrepriseEmail: entreprise['email'] ?? '',
      lignes: (json['lignes'] as List? ?? [])
          .map((e) => MallLigneCommande.fromJson(e))
          .toList(),
    );
  }
}
