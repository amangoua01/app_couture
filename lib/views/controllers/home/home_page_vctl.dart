import 'dart:async';

import 'package:ateliya/api/accueil_api.dart';
import 'package:ateliya/data/models/accueil_data.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';

class HomePageVctl extends AuthViewController with PrinterManagerViewMixin {
  var data = AccueilData();
  final api = AccueilApi();

  Timer? _notifTimer;

  Future<void> loadData() async {
    final entite = getEntite().value;
    loadUnreadCount();
    if (entite.isNotEmpty) {
      final res = await api.getAccueilData(entite.id!, entite.type).load();
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
    // Rafraîchir le compteur de notifications toutes les 2 minutes
    _notifTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      loadUnreadCount();
    });
    super.onReady();
  }

  @override
  void onClose() {
    _notifTimer?.cancel();
    super.onClose();
  }
}
