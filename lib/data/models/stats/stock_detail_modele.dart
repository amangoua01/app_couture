class StockDetailModele {
  int? modeleBoutiqueId;
  String? libelle;
  String? taille;
  String? couleur;
  String? prix;
  int? stockActuel;
  int? qteEntree;
  int? qteSortie;
  int? nbMouvements;

  StockDetailModele({
    this.modeleBoutiqueId,
    this.libelle,
    this.taille,
    this.couleur,
    this.prix,
    this.stockActuel,
    this.qteEntree,
    this.qteSortie,
    this.nbMouvements,
  });

  StockDetailModele.fromJson(Map<String, dynamic> json) {
    modeleBoutiqueId = json['modeleBoutiqueId'];
    libelle = json['libelle'];
    taille = json['taille'];
    couleur = json['couleur'];
    prix = json['prix']?.toString();
    stockActuel = json['stockActuel'];
    qteEntree = json['qteEntree'];
    qteSortie = json['qteSortie'];
    nbMouvements = json['nbMouvements'];
  }

  Map<String, dynamic> toJson() => {
        'modeleBoutiqueId': modeleBoutiqueId,
        'libelle': libelle,
        'taille': taille,
        'couleur': couleur,
        'prix': prix,
        'stockActuel': stockActuel,
        'qteEntree': qteEntree,
        'qteSortie': qteSortie,
        'nbMouvements': nbMouvements,
      };
}
