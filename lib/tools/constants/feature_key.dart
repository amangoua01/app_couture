enum FeatureKey {
  fullAccess,
  gestionArticles,
  gestionAchatArticles,
  gestionMagasins,
  gestionModePaiements,
  gestionPersonnel,
  gestionMatieresPremieres,
  gestionProduits,
  gestionProductions,
  gestionServices,
  gestionUnites,
  gestionTaxe,
  gestionVentes,
  gestionCommandes,
  gestionCharges,
  gestionDepenses,
  gestionClients,
  gestionFournisseurs,
  gestionRoles,
  gestionCaisses,
  dashboard;

  static FeatureKey fromString(String key) {
    return FeatureKey.values.firstWhere(
      (element) => element.name.toLowerCase() == key.toLowerCase(),
      orElse: () => FeatureKey.fullAccess,
    );
  }
}
