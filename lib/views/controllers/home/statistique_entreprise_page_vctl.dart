import 'package:ateliya/api/statistique_api.dart';
import 'package:ateliya/data/models/stats/globale_stats.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/static/stats/bilan_pdf_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Statistiques globales de l'entreprise.
///
/// Chaque période (0 jour, 1 mois, 2 année, 3 plage libre) garde ses chiffres :
/// on glisse d'un onglet à l'autre sans attendre. Le filtre « Ensemble /
/// Boutiques / Ateliers » ne recharge rien, il change seulement la lecture.
class StatistiqueEntreprisePageVctl extends AuthViewController {
  int periodIndex = 0;
  int scope = 0; // 0 ensemble, 1 boutiques, 2 ateliers
  final api = StatistiqueApi();

  final Map<int, GlobaleStats> _byPeriod = {};
  final Set<int> _loading = {};
  var dateRange = CustomDateTimeRange.now();

  int get selectedIndex => periodIndex;
  set selectedIndex(int value) => periodIndex = value;

  GlobaleStats? dataFor(int index) => _byPeriod[index];
  bool hasData(int index) => _byPeriod.containsKey(index);
  bool get isLoading => _loading.contains(periodIndex) && !hasData(periodIndex);

  /// Vrai tant que la période affichée se charge (même avec d'anciens chiffres).
  bool get isLoadingAny => _loading.contains(periodIndex);

  @visibleForTesting
  void seed(int index, GlobaleStats value) => _byPeriod[index] = value;

  void setScope(int value) {
    if (value == scope) return;
    scope = value;
    update();
  }

  /// Bloc à afficher pour la période et le filtre courants.
  StatistiquesBoutique blockFor(GlobaleStats g) => switch (scope) {
    1 => g.boutiques,
    2 => g.ateliers,
    _ => g.ensemble,
  };

  PeriodStatReq _paramsFor(int index, DateTimeRange? range) {
    final p = PeriodStatReq()..filtre = PeriodStat.values[index];
    if (index == 0) {
      final today = CustomDateTimeRange.now();
      p.dateDebut = today.start;
      p.dateFin = today.end;
    } else if (index == 3 && range != null) {
      p.dateDebut = range.start;
      p.dateFin = range.end;
    }
    return p;
  }

  Future<void> _load(int index, {DateTimeRange? range}) async {
    if (!_loading.add(index)) return;
    update();
    final params = _paramsFor(index, range);
    var res = await api.getGlobale(params);
    if (!res.status) {
      await Future.delayed(const Duration(seconds: 1));
      res = await api.getGlobale(params);
    }
    _loading.remove(index);
    if (res.status && res.data != null) {
      _byPeriod[index] = res.data!;
    } else if (index == periodIndex && !hasData(index)) {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  Future<void> _prefetchNeighbours() async {
    for (final i in const [1, 0, 2]) {
      if (i != periodIndex && !hasData(i)) await _load(i);
    }
  }

  Future<void> selectPeriod(int index) async {
    if (index == periodIndex && hasData(index)) return;
    periodIndex = index;
    update();
    if (!hasData(index)) await _load(index);
  }

  Future<void> refreshCurrent() =>
      _load(periodIndex, range: periodIndex == 3 ? dateRange : null);

  Future<void> fetchStats({int indexPeriod = 0, DateTimeRange? range}) async {
    periodIndex = indexPeriod;
    if (range != null) dateRange = range;
    update();
    await _load(indexPeriod, range: indexPeriod == 3 ? dateRange : null);
  }

  String get periodeLabel {
    switch (periodIndex) {
      case 0:
        return "journalier (${CustomDateTimeRange.now().toFrenchDate})";
      case 1:
        return "mensuel";
      case 2:
        return "annuel";
      default:
        return dateRange.toFrenchDate;
    }
  }

  void exportBilanPdf() {
    final g = dataFor(periodIndex);
    if (g == null) return;
    Get.to(
      () => BilanPdfPreviewPage(
        data: blockFor(g),
        periodeLabel: periodeLabel,
        entreprise: user.entreprise,
      ),
    );
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _byPeriod.remove(3);
      await fetchStats(indexPeriod: 3, range: picked);
    }
  }

  @override
  void onReady() {
    _load(periodIndex).then((_) => _prefetchNeighbours());
    super.onReady();
  }
}
