import 'package:ateliya/api/caisse_api.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/mouvement_caisse.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/models/paginated_data.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class MouvementCaisseListVctl extends AuthViewController {
  final _api = CaisseApi();

  PaginatedData<MouvementCaisse> data = PaginatedData<MouvementCaisse>();
  bool isLoading = false;

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().firstDayOfMonth,
    end: DateTime.now().lastDayOfMonth,
  );

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  Future<void> fetchData({int page = 1}) async {
    final entite = getEntite().value;
    if (entite is! Boutique || entite.id == null) return;

    final dateDebut = dateRange.start.toIso8601String().split('T')[0];
    final dateFin = dateRange.end.toIso8601String().split('T')[0];

    if (page == 1) {
      // On ne vide la liste qu'au moment où on a quelque chose à montrer à
      // la place (cache ou réponse réseau) : sinon l'écran clignote à vide
      // à chaque ouverture ou changement de période.
      final cached = await _api.readCachedMouvements(
        boutiqueId: entite.id!,
        dateDebut: dateDebut,
        dateFin: dateFin,
      );
      if (cached != null) {
        data = cached;
      } else {
        data.clear();
      }
      isLoading = data.isEmpty;
      update();
    }

    final res = await _api.listMouvements(
      boutiqueId: entite.id!,
      dateDebut: dateDebut,
      dateFin: dateFin,
      page: page,
    );

    if (res.status && res.data != null) {
      if (page == 1) {
        data = res.data!;
      } else {
        data.append(res.data!);
      }
    }

    isLoading = false;
    update();
  }

  void updateDateRange(DateTimeRange range) {
    dateRange = range;
    fetchData();
  }
}
