import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class BoutiquePageVctl extends AuthViewController {
  bool isLoading = false;

  /// Données brutes reçues de l'API
  List<StockModeleItem> _allData = [];

  /// Données filtrées affichées dans la vue
  List<StockModeleItem> data = [];

  /// Contrôleur du champ de recherche
  final searchCtl = TextEditingController();
  String _query = '';

  final api = BoutiqueApi();

  Future<void> fetchData() async {
    if (getEntite().value.isNotEmpty) {
      isLoading = true;
      update();
      final res = await api.getModeleBoutiqueByBoutiqueId(
        getEntite().value.id.value,
      );
      isLoading = false;
      if (res.status) {
        _allData = res.data!;
        _applyFilter();
      } else {
        CMessageDialog.show(message: res.message);
        update();
      }
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
      data = _allData.where((item) {
        final libelle = (item.modele?.libelle ?? '').toLowerCase();
        // Recherche aussi dans les tailles et prix du bilan
        final tailles =
            item.bilan.parTaille.keys.map((t) => t.toLowerCase()).join(' ');
        final prix =
            item.bilan.parPrix.keys.map((p) => p.toLowerCase()).join(' ');
        return libelle.contains(_query) ||
            tailles.contains(_query) ||
            prix.contains(_query);
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
    searchCtl.dispose();
    super.onClose();
  }
}
