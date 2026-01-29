import 'package:ateliya/api/statistique_api.dart';
import 'package:ateliya/data/dto/dash_item_dto.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class HomePageVctl extends AuthViewController {
  var data = StatistiquesBoutique();
  final api = StatistiqueApi();
  DateTimeRange periode = CustomDateTimeRange.now();

  Future<void> loadData() async {
    if (getEntite().value.isNotEmpty) {
      final params = DashItemDto(
        id: getEntite().value.id.value,
        dateDebut: periode.start,
        dateFin: periode.end,
        valeur: '',
      );
      final res =
          await api.getDashboardData(params, getEntite().value.type).load();
      if (res.status) {
        data = res.data!;
        update();
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }
}
