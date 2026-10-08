import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoutiquePageVctl extends AuthViewController {
  bool isLoading = false;

  /// Vrai dès qu'une lecture de l'API a abouti.
  ///
  /// Sans ce repère, la vue ne distinguait pas « boutique réellement vide » de
  /// « rien n'a encore été chargé » : elle annonçait donc « Aucun article » à
  /// l'arrivée, et il fallait tirer vers le bas pour voir le stock.
  bool hasLoadedOnce = false;

  /// Attente de l'entité active, le temps que le sélecteur de l'app bar la
  /// résolve.
  Worker? _attenteEntite;

  /// Données brutes reçues de l'API
  List<StockModeleItem> _allData = [];

  /// Données filtrées affichées dans la vue
  List<StockModeleItem> data = [];

  /// Contrôleur du champ de recherche
  final searchCtl = TextEditingController();
  String _query = '';

  final api = BoutiqueApi();
  final modeleBoutiqueApi = ModeleBoutiqueApi();

  Future<void> fetchData() async {
    final entite = getEntite();

    // L'entité active n'est pas toujours résolue au moment où la page s'ouvre.
    // Auparavant la méthode se contentait de ne rien faire : l'écran restait
    // donc sur « Aucun article » sans jamais rien demander au serveur. On reste
    // désormais en chargement et on relance dès que l'entité arrive.
    if (entite.value.isEmpty) {
      isLoading = true;
      update();
      _attenteEntite?.dispose();
      _attenteEntite = ever<EntiteEntreprise>(entite, (valeur) {
        if (valeur.isNotEmpty) {
          _attenteEntite?.dispose();
          _attenteEntite = null;
          fetchData();
        }
      });
      return;
    }

    final boutiqueId = entite.value.id.value;

    // Affichage immédiat du dernier stock connu, puis rafraîchissement en
    // arrière-plan. L'écran n'attend plus le réseau pour montrer quelque chose
    // dès lors qu'il a déjà été consulté.
    if (!hasLoadedOnce) {
      final cache = await api.readCachedModeleBoutique(boutiqueId);
      if (cache != null && cache.isNotEmpty) {
        _allData = cache;
        hasLoadedOnce = true;
        _applyFilter();
      }
    }

    isLoading = !hasLoadedOnce;
    update();

    final res = await api.getModeleBoutiqueByBoutiqueId(boutiqueId);
    isLoading = false;
    if (res.status) {
      hasLoadedOnce = true;
      _allData = res.data!;
      _applyFilter();
    } else {
      // Avec des données en cache à l'écran, une panne réseau n'a pas à
      // déclencher une fenêtre d'erreur : l'utilisateur voit déjà son stock.
      if (!hasLoadedOnce) {
        hasLoadedOnce = true;
        CMessageDialog.show(message: res.message);
      }
      update();
    }
  }

  void onSearch(String query) {
    _query = query.trim().toLowerCase();
    _applyFilter();
  }

  void clearSearch() {
    searchCtl.clear();
    _query = '';
    _applyFilter();
  }

  bool get hasQuery => _query.isNotEmpty;

  void _applyFilter() {
    if (_query.isEmpty) {
      data = List.from(_allData);
    } else {
      data =
          _allData.where((item) {
            final libelle = (item.modele?.libelle ?? '').toLowerCase();
            // Recherche aussi dans les tailles et prix du bilan
            final tailles = item.bilan.parTaille.keys
                .map((t) => t.toLowerCase())
                .join(' ');
            final prix = item.bilan.parPrix.keys
                .map((p) => p.toLowerCase())
                .join(' ');
            // Recherche dans les codes-barres des variantes
            final codes = item.variantes
                .map((v) => (v.codeBarre ?? '').toLowerCase())
                .join(' ');
            return libelle.contains(_query) ||
                tailles.contains(_query) ||
                prix.contains(_query) ||
                codes.contains(_query);
          }).toList();
    }
    update();
  }

  @override
  void onReady() {
    fetchData();
    super.onReady();
  }

  @override
  void onClose() {
    _attenteEntite?.dispose();
    searchCtl.dispose();
    super.onClose();
  }
}
