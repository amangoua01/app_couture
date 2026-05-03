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

    isLoading = true;
    update();

    final res = await api.getDashboardData(params).load();

    isLoading = false;
    if (res.status) {
      data = res.data!;
      update();
    } else {
      update();
      CMessageDialog.show(message: res.message);
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
