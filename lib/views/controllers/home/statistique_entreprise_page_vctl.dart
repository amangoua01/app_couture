import 'package:ateliya/api/statistique_api.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class StatistiqueEntreprisePageVctl extends AuthViewController {
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
      if (params.filtre == PeriodStat.jour) {
        dateRange = CustomDateTimeRange.now();
        params.dateDebut = dateRange.start;
        params.dateFin = dateRange.end;
      } else {
        params.dateDebut = null;
        params.dateFin = null;
      }
    }

    // Réaffiche les dernières statistiques connues pour cette période le
    // temps que le réseau réponde.
    final cached = await api.readCachedDashboardData(params);
    final hasContent = cached != null;
    if (hasContent) {
      data = cached;
      update();
    }

    isLoading = !hasContent;
    update();

    // Le voile de chargement bloquant ne sert qu'au tout premier chargement :
    // une fois des données affichées, on rafraîchit en silence.
    final request = api.getDashboardData(params);
    var res = await (hasContent ? request : request.load());

    // Retry une fois en cas d'erreur réseau
    if (!res.status) {
      await Future.delayed(const Duration(seconds: 1));
      final retryRequest = api.getDashboardData(params);
      res = await (hasContent ? retryRequest : retryRequest.load());
    }

    isLoading = false;
    if (res.status) {
      data = res.data!;
      update();
    } else {
      update();
      if (!hasContent) CMessageDialog.show(message: res.message);
    }
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
    fetchStats();
    super.onReady();
  }
}
