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

class StatistiquePageVctl extends AuthViewController {
  int periodIndex = 0;
  final api = StatistiqueApi();
  final params = PeriodStatReq();
  bool isLoading = false;
  StatistiquesBoutique data = StatistiquesBoutique();
  var dateRange = CustomDateTimeRange.now();

  int get selectedIndex => periodIndex;
  set selectedIndex(int value) => periodIndex = value;

  Future<void> fetchStats({int indexPeriod = 0, DateTimeRange? range}) async {
    params.filtre = PeriodStat.values[indexPeriod];
    periodIndex = indexPeriod;

    if (range != null) {
      dateRange = range;
      params.dateDebut = range.start;
      params.dateFin = range.end;
    } else {
      // Réinitialiser les dates si on clique sur un raccourci (jour, mois, année)
      if (params.filtre == PeriodStat.jour) {
        dateRange = CustomDateTimeRange.now();
        params.dateDebut = dateRange.start;
        params.dateFin = dateRange.end;
      } else {
        params.dateDebut = null;
        params.dateFin = null;
      }
    }

    isLoading = true;
    update();

    final entite = getEntite().value;
    var res = await api.getData(
      entite.id.value,
      params,
      entite.type,
    );

    // Retry une fois en cas d'erreur réseau (ex: Connection closed)
    if (!res.status) {
      await Future.delayed(const Duration(seconds: 1));
      res = await api.getData(
        entite.id.value,
        params,
        entite.type,
      );
    }

    isLoading = false;
    if (res.status) {
      data = res.data!;
    } else {
      CMessageDialog.show(message: res.message);
    }
    update();
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
      fetchStats(indexPeriod: 3, range: picked);
    }
  }

  @override
  void onReady() {
    if (entities.isNotEmpty) {
      fetchStats();
    }
    super.onReady();
  }
}
