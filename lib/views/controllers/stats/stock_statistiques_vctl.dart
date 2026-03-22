import 'package:ateliya/api/statistique_api.dart';
import 'package:ateliya/data/models/stats/stock_statistiques.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class StockStatistiquesVctl extends AuthViewController {
  final _api = StatistiqueApi();

  StockStatistiques? data;
  bool isLoading = true;

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

    isLoading = true;
    update();

    final res = await _api.getStockStatistiques(entite.id!, params);
    if (res.status && res.data != null) {
      data = res.data;
    }

    isLoading = false;
    update();
  }

  void updatePeriod(PeriodStat filtre, {DateTime? debut, DateTime? fin}) {
    params.filtre = filtre;
    params.dateDebut = debut;
    params.dateFin = fin;
    periodIndex = PeriodStat.values.indexOf(filtre);
    fetchData();
  }
}
