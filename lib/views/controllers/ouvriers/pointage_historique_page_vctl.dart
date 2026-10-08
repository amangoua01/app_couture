import 'package:ateliya/api/pointage_api.dart';
import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/data/models/pointage.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PointageHistoriquePageVctl extends AuthViewController {
  final Employe employe;
  PointageHistoriquePageVctl(this.employe);

  final _api = PointageApi();
  bool isLoading = true;
  List<Pointage> pointages = [];

  DateTimeRange range = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 29)),
    end: DateTime.now(),
  );

  String get _debutStr => DateFormat('yyyy-MM-dd').format(range.start);
  String get _finStr => DateFormat('yyyy-MM-dd').format(range.end);

  @override
  void onReady() {
    super.onReady();
    charger();
  }

  Future<void> charger() async {
    isLoading = true;
    update();

    final res = await _api.listForPeriod(_debutStr, _finStr, employeId: employe.id);
    if (res.status) {
      pointages = res.data ?? [];
      // Les plus récents d'abord.
      pointages.sort((a, b) => (b.dateJour ?? '').compareTo(a.dateJour ?? ''));
    } else {
      CMessageDialog.show(message: res.message);
    }

    isLoading = false;
    update();
  }

  Future<void> pickRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: range,
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
      range = picked;
      charger();
    }
  }
}
