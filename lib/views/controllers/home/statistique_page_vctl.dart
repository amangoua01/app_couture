import 'package:ateliya/api/statistique_api.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Statistiques de l'entité (boutique ou atelier) choisie.
///
/// Chaque période (0 jour, 1 mois, 2 année, 3 plage personnalisée) garde ses
/// propres chiffres : on peut ainsi glisser d'un onglet à l'autre sans
/// attendre, les périodes voisines étant chargées en arrière-plan.
class StatistiquePageVctl extends AuthViewController {
  int periodIndex = 0;
  final api = StatistiqueApi();

  final Map<int, StatistiquesBoutique> _byPeriod = {};
  final Set<int> _loading = {};
  var dateRange = CustomDateTimeRange.now();

  int get selectedIndex => periodIndex;
  set selectedIndex(int value) => periodIndex = value;

  /// Chiffres de la période affichée (vides tant qu'ils ne sont pas arrivés).
  StatistiquesBoutique get data => _byPeriod[periodIndex] ?? StatistiquesBoutique();

  StatistiquesBoutique? dataFor(int index) => _byPeriod[index];

  /// Injecte des chiffres déjà connus (tests).
  @visibleForTesting
  void seed(int index, StatistiquesBoutique value) => _byPeriod[index] = value;
  bool hasData(int index) => _byPeriod.containsKey(index);

  /// Vrai tant que la période affichée n'a encore rien à montrer.
  bool get isLoading => _loading.contains(periodIndex) && !hasData(periodIndex);

  /// Vrai pendant l'actualisation d'une période déjà affichée.
  bool get isRefreshing => _loading.contains(periodIndex) && hasData(periodIndex);

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
    final entite = getEntite().value;
    if (entite.id == null) return;
    if (!_loading.add(index)) return; // déjà en cours
    update();

    final params = _paramsFor(index, range);
    var res = await api.getData(entite.id.value, params, entite.type);

    // Un seul nouvel essai en cas de coupure réseau (ex : Connection closed).
    if (!res.status) {
      await Future.delayed(const Duration(seconds: 1));
      res = await api.getData(entite.id.value, params, entite.type);
    }

    _loading.remove(index);
    if (res.status && res.data != null) {
      _byPeriod[index] = res.data!;
    } else if (index == periodIndex && !hasData(index)) {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  /// Charge les périodes voisines sans bloquer l'écran.
  Future<void> _prefetchNeighbours() async {
    for (final i in const [1, 0, 2]) {
      if (i != periodIndex && !hasData(i)) await _load(i);
    }
  }

  /// Affiche la période [index] : tout de suite si elle est déjà connue,
  /// sinon après chargement.
  Future<void> selectPeriod(int index) async {
    if (index == periodIndex && hasData(index)) return;
    periodIndex = index;
    update();
    if (!hasData(index)) await _load(index);
  }

  /// Recharge la période affichée (tirer pour actualiser).
  Future<void> refreshCurrent() async {
    await _load(periodIndex, range: periodIndex == 3 ? dateRange : null);
  }

  /// Repart de zéro (changement de boutique ou d'atelier).
  Future<void> reloadAll() async {
    _byPeriod.clear();
    _loading.clear();
    update();
    await _load(periodIndex, range: periodIndex == 3 ? dateRange : null);
    _prefetchNeighbours();
  }

  /// Conservé pour les appelants existants : (re)charge une période.
  Future<void> fetchStats({int indexPeriod = 0, DateTimeRange? range}) async {
    periodIndex = indexPeriod;
    if (range != null) dateRange = range;
    update();
    await _load(indexPeriod, range: indexPeriod == 3 ? dateRange : null);
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _byPeriod.remove(3);
      await fetchStats(indexPeriod: 3, range: picked);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // L'écran reste vivant dans la barre du bas : sans cet abonnement, choisir
    // une autre boutique ou un autre atelier depuis un autre onglet laissait
    // ici « Aucune entité sélectionnée » ou les chiffres de l'entité précédente.
    _surveilleEntite = ever(getEntite(), (_) => reloadAll());
  }

  Worker? _surveilleEntite;

  @override
  void onClose() {
    _surveilleEntite?.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    if (getEntite().value.id != null) {
      _load(periodIndex).then((_) => _prefetchNeighbours());
    }
    super.onReady();
  }
}
