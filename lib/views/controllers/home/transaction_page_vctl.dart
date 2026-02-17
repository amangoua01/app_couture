import 'package:ateliya/api/facture_api.dart';
import 'package:ateliya/data/models/transaction_response.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TransactionPageVctl extends AuthViewController {
  final factureApi = FactureApi();
  TransactionResponse? data;

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();

  bool isLoading = false;

  bool get isMonthMode => selectedDay == null;

  String get formattedDate {
    if (isMonthMode) {
      return DateFormat('MMMM yyyy', 'fr').format(focusedDay).capitalize();
    }
    return DateFormat('d MMMM yyyy', 'fr').format(selectedDay!).capitalize();
  }

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting('fr', null);
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading = true;
    update();

    DataResponse<TransactionResponse> res;

    final monthStr =
        "${focusedDay.year}-${focusedDay.month.toString().padLeft(2, '0')}";

    final entity = getEntite().value;
    if (isMonthMode) {
      res = await factureApi.getTransactions(
        entityId: entity.id.value,
        type: entity.type.name,
        month: monthStr,
      );
    } else {
      final dateStr = selectedDay!.toIso8601String().split('T')[0];
      res = await factureApi.getTransactions(
        entityId: entity.id.value,
        type: entity.type.name,
        date: dateStr,
        month: monthStr,
      );
    }

    isLoading = false;
    if (res.status) {
      data = res.data;
    } else {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  void onDateSelected(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    fetchData();
  }

  void onPageChanged(DateTime focused) {
    focusedDay = focused;
    if (isMonthMode) {
      fetchData();
    } else {
      update();
    }
  }

  void toggleMode() {
    if (isMonthMode) {
      // Switch to Day mode
      selectedDay = focusedDay;
    } else {
      // Switch to Month mode
      selectedDay = null;
    }
    fetchData();
  }
}
