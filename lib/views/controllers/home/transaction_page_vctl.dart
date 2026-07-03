import 'dart:async';

import 'package:ateliya/api/facture_api.dart';
import 'package:ateliya/data/models/transaction_response.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

enum TransactionFilterMode { jour, mois, plage }

class TransactionPageVctl extends AuthViewController {
  final factureApi = FactureApi();
  TransactionResponse? data;

  DateTime focusedDay = DateTime.now();
  TransactionFilterMode mode = TransactionFilterMode.jour;
  DateTimeRange? selectedRange;

  bool isLoading = false;

  StreamSubscription? _entiteSubscription;

  final _fmt = DateFormat('yyyy-MM-dd');

  String get formattedDate {
    switch (mode) {
      case TransactionFilterMode.mois:
        return DateFormat('MMMM yyyy', 'fr').format(focusedDay).capitalize();
      case TransactionFilterMode.plage:
        if (selectedRange != null) {
          final df = DateFormat('d MMM yyyy', 'fr');
          return '${df.format(selectedRange!.start)} – ${df.format(selectedRange!.end)}';
        }
        return 'Plage de dates';
      case TransactionFilterMode.jour:
      default:
        return DateFormat('d MMMM yyyy', 'fr').format(focusedDay).capitalize();
    }
  }

  /// Calcule date_debut et date_fin selon le mode
  (String, String) get _dateRange {
    switch (mode) {
      case TransactionFilterMode.mois:
        final first = DateTime(focusedDay.year, focusedDay.month, 1);
        final last = DateTime(focusedDay.year, focusedDay.month + 1, 0);
        return (_fmt.format(first), _fmt.format(last));
      case TransactionFilterMode.plage:
        if (selectedRange != null) {
          return (
            _fmt.format(selectedRange!.start),
            _fmt.format(selectedRange!.end),
          );
        }
        final today = DateTime.now();
        return (_fmt.format(today), _fmt.format(today));
      case TransactionFilterMode.jour:
      default:
        final d = _fmt.format(focusedDay);
        return (d, d);
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting('fr', null);
  }

  @override
  void onReady() {
    super.onReady();
    _entiteSubscription = getEntite().listen((_) {
      if (getEntite().value.isNotEmpty) fetchData();
    });
    if (getEntite().value.isNotEmpty) fetchData();
  }

  @override
  void onClose() {
    _entiteSubscription?.cancel();
    super.onClose();
  }

  Future<void> fetchData() async {
    final entity = getEntite().value;
    if (entity.isEmpty) return;

    isLoading = true;
    update();

    final (dateDebut, dateFin) = _dateRange;

    final DataResponse<TransactionResponse> res =
        await factureApi.getTransactions(
      entityId: entity.id.value,
      type: entity.type.name,
      dateDebut: dateDebut,
      dateFin: dateFin,
    );

    isLoading = false;
    if (res.status) {
      data = res.data;
    } else {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  void onDaySelected(DateTime selected) {
    focusedDay = selected;
    mode = TransactionFilterMode.jour;
    fetchData();
  }

  void onPageChanged(DateTime focused) {
    focusedDay = focused;
    if (mode == TransactionFilterMode.mois)
      fetchData();
    else
      update();
  }

  void selectMonth() {
    mode = TransactionFilterMode.mois;
    fetchData();
  }

  void onRangeSelected(DateTimeRange range) {
    selectedRange = range;
    mode = TransactionFilterMode.plage;
    fetchData();
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
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
    if (picked != null) onRangeSelected(picked);
  }
}
