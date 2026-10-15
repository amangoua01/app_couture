import 'dart:async';

import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/api/reservation_api.dart';
import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Filtre rapide de la liste : répond à « qu'est-ce qui manque ? » sans taper.
enum StockFiltre { tous, enStock, stockBas, rupture }

class BoutiquePageVctl extends AuthViewController {
  /// En dessous de ce seuil (inclus), un modèle est signalé en stock bas.
  static const seuilStockBas = 5;

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
  Timer? _debounce;

  StockFiltre filtre = StockFiltre.tous;

  int get nbTous => _allData.length;
  int get nbEnStock => _allData.where((e) => e.quantiteBoutique > 0).length;
  int get nbRupture => _allData.where((e) => e.quantiteBoutique <= 0).length;
  int get nbStockBas =>
      _allData
          .where(
            (e) =>
                e.quantiteBoutique > 0 && e.quantiteBoutique <= seuilStockBas,
          )
          .length;

  void setFiltre(StockFiltre value) {
    if (filtre == value) return;
    filtre = value;
    _applyFilter();
  }

  bool _passeFiltre(StockModeleItem item) {
    final q = item.quantiteBoutique;
    switch (filtre) {
      case StockFiltre.tous:
        return true;
      case StockFiltre.enStock:
        return q > 0;
      case StockFiltre.stockBas:
        return q > 0 && q <= seuilStockBas;
      case StockFiltre.rupture:
        return q <= 0;
    }
  }

  final api = BoutiqueApi();
  final modeleBoutiqueApi = ModeleBoutiqueApi();
  final _reservationApi = ReservationApi();

  /// Réservations à traiter (en attente ou en attente de stock), pour le badge
  /// du bouton « Réservations ». Chargé à part : il ne doit jamais retarder
  /// l'affichage du stock.
  int nbReservationsATraiter = 0;

  Future<void> chargerReservations() async {
    final entite = getEntite().value;
    if (entite.isEmpty) return;
    // Le dernier compte connu s'affiche tout de suite, le réseau le corrige.
    final cache = await _reservationApi.readCachedByBoutique(entite.id.value);
    if (cache != null) {
      nbReservationsATraiter =
          cache.where((r) => r.statut.peutConfirmer).length;
      update();
    }
    final res = await _reservationApi.listByBoutique(entite.id.value);
    if (res.status) {
      nbReservationsATraiter =
          res.data!.where((r) => r.statut.peutConfirmer).length;
      update();
    }
  }

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
      chargerReservations();
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

  /// La recherche attend une courte pause de frappe : filtrer et reconstruire
  /// toute la liste à chaque lettre était inutilement coûteux.
  void onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _query = query.trim().toLowerCase();
      _applyFilter();
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    searchCtl.clear();
    _query = '';
    filtre = StockFiltre.tous;
    _applyFilter();
  }

  bool get hasQuery => _query.isNotEmpty || filtre != StockFiltre.tous;

  void _applyFilter() {
    final base =
        filtre == StockFiltre.tous
            ? _allData
            : _allData.where(_passeFiltre).toList();
    if (_query.isEmpty) {
      data = List.from(base);
    } else {
      data =
          base.where((item) {
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
    _debounce?.cancel();
    _attenteEntite?.dispose();
    searchCtl.dispose();
    super.onClose();
  }
}
