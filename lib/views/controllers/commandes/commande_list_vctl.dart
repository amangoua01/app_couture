import 'package:ateliya/api/facture_api.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class CommandeListVctl extends AuthViewController {
  final api = FactureApi();
  final int initialTab;

  CommandeListVctl({this.initialTab = 0});

  bool isLoading = false;
  bool isLoadingMore = false;
  List<Mesure> items = [];
  int currentPage = 1;
  int totalPages = 1;

  // Filtres
  final dateDebut = DateTimeEditingController();
  final dateFin = DateTimeEditingController();
  final nomClientCtrl = TextEditingController();
  final numeroClientCtrl = TextEditingController();
  String? etatFacture;

  late int _tabIndex = initialTab;
  int get tabIndex => _tabIndex;
  set tabIndex(int val) {
    _tabIndex = val;
    getList();
  }

  // 5 tabs alignés exactement sur les valeurs type de l'API
  static const tabs = [
    ('NONTERMINEE', 'Non terminées'),
    ('SOLDEESNONTERMINEE', 'Soldées non term.'),
    ('TERMINEE', 'Terminées'),
    ('LIVRER', 'Livrées'),
    ('RETIRE', 'Retirées'),
  ];

  String get _currentType => tabs[_tabIndex].$1;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  Future<void> getList() async {
    isLoading = true;
    currentPage = 1;
    items.clear();
    update();

    final dateDebutStr = dateDebut.dateTime?.toIso8601String().split('T').first;
    final dateFinStr = dateFin.dateTime?.toIso8601String().split('T').first;

    final res = await api.getFacturesEntreprisePaginated(
      getEntite().value.id.value,
      page: currentPage,
      type: _currentType,
      dateDebut: dateDebutStr,
      dateFin: dateFinStr,
      nomClient: nomClientCtrl.text.trim(),
      numeroClient: numeroClientCtrl.text.trim(),
      etatFacture: etatFacture,
    );

    isLoading = false;

    if (res.status) {
      items = res.data?.items ?? [];
      totalPages = res.data?.totalPages ?? 1;
    } else {
      CMessageDialog.show(message: res.message);
    }

    update();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || currentPage >= totalPages) return;
    isLoadingMore = true;
    currentPage++;
    update();

    final dateDebutStr = dateDebut.dateTime?.toIso8601String().split('T').first;
    final dateFinStr = dateFin.dateTime?.toIso8601String().split('T').first;

    final res = await api.getFacturesEntreprisePaginated(
      getEntite().value.id.value,
      page: currentPage,
      type: _currentType,
      dateDebut: dateDebutStr,
      dateFin: dateFinStr,
      nomClient: nomClientCtrl.text.trim(),
      numeroClient: numeroClientCtrl.text.trim(),
      etatFacture: etatFacture,
    );

    isLoadingMore = false;

    if (res.status) {
      items.addAll(res.data?.items ?? []);
      totalPages = res.data?.totalPages ?? 1;
    } else {
      currentPage--;
      CMessageDialog.show(message: res.message);
    }

    update();
  }

  void resetFilters() {
    dateDebut.clear();
    dateFin.clear();
    nomClientCtrl.clear();
    numeroClientCtrl.clear();
    etatFacture = null;
    getList();
  }
}
