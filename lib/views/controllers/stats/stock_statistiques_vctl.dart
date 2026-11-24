import 'package:ateliya/api/statistique_api.dart';
import 'package:ateliya/data/models/stats/stock_statistiques.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class StockStatistiquesVctl extends AuthViewController {
  final _api = StatistiqueApi();

  StockStatistiques? data;
  bool isLoading = true;

  /// Vrai pendant tout appel réseau, y compris quand d'anciens chiffres sont
  /// déjà affichés : l'écran le signale par un filet de chargement.
  bool isRefreshing = false;

  /// Message renvoyé par le serveur quand le chargement échoue (abonnement
  /// requis, boutique introuvable…) : sans lui, la page affichait des zéros
  /// trompeurs.
  String? errorMessage;

  PeriodStatReq params = PeriodStatReq(filtre: PeriodStat.mois);
  int periodIndex = 1;

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  Future<void> fetchData() async {
    final entite = getEntite().value;
    if (entite.id == null) {
      isLoading = false;
      update();
      return;
    }

    // Réaffiche les dernières statistiques connues pour cette période le
    // temps que le réseau réponde.
    final cached = await _api.readCachedStockStatistiques(entite.id!, params);
    if (cached != null) {
      data = cached;
      update();
    }

    isLoading = cached == null;
    isRefreshing = true;
    update();

    final res = await _api.getStockStatistiques(entite.id!, params);
    if (res.status && res.data != null) {
      data = res.data;
      errorMessage = null;
    } else if (data == null) {
      errorMessage = res.message;
    }

    isLoading = false;
    isRefreshing = false;
    update();
  }

  void updatePeriod(PeriodStat filtre, {DateTime? debut, DateTime? fin}) {
    params.filtre = filtre;
    params.dateDebut = debut;
    params.dateFin = fin;
    periodIndex = PeriodStat.values.indexOf(filtre);
    update();
    fetchData();
  }
}
