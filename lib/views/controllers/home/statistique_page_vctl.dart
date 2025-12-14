import 'package:ateliya/api/statistique_api.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class StatistiquePageVctl extends AuthViewController {
  int periodIndex = 0;
  final api = StatistiqueApi();
  final params = PeriodStatReq();
  bool isLoading = false;
  StatistiquesBoutique data = StatistiquesBoutique();
  var dateRange = CustomDateTimeRange.now();

  Future<void> fetchStats({int indexPeriod = 0}) async {
    params.filtre = PeriodStat.values[indexPeriod];
    periodIndex = indexPeriod;
    update();
    final res = await api.getData(1, params).load();
    if (res.status) {
      data = res.data!;
      update();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  @override
  void onReady() {
    if (!entities.isEmpty) {
      fetchStats();
    }
    super.onReady();
  }
}
