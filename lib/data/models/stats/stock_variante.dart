class StockVariante {
  int? modeleBoutiqueId;
  String? taille;
  String? couleur;
  String? prix;
  int? stock;

  StockVariante({
    this.modeleBoutiqueId,
    this.taille,
    this.couleur,
    this.prix,
    this.stock,
  });

  StockVariante.fromJson(Map<String, dynamic> json) {
    modeleBoutiqueId = json['modeleBoutiqueId'];
    taille = json['taille'];
    couleur = json['couleur'];
    prix = json['prix']?.toString();
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() => {
        'modeleBoutiqueId': modeleBoutiqueId,
        'taille': taille,
        'couleur': couleur,
        'prix': prix,
        'stock': stock,
      };
}
