import 'dart:async';

import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/services/app_review_service.dart';
import 'package:ateliya/tools/services/notification_service.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/static/home/home_page/home_page.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/page_boutique/boutique_page.dart';
import 'package:ateliya/views/static/home/sub_pages/setting_page.dart';
import 'package:ateliya/views/static/home/sub_pages/statistique_page.dart';
import 'package:ateliya/views/static/home/sub_pages/transaction_page.dart';

class HomeWindowsVctl extends AuthViewController {
  int page = 0;
  final authApi = AuthApi();
  Timer? _notifTimer;
  EntiteEntreprise? _lastEntite;

  StreamSubscription? _entiteSubscription;

  final pages = const [
    HomePage(),
    StatistiquePage(),
    TransactionPage(),
    SettingPage(),
    BoutiquePage(),
  ];

  void onEntiteChanged() {
    final current = getEntite().value;
    final last = _lastEntite;
    // Si le type change (boutique <-> succursale), reset à la page 0
    if (last != null && last.runtimeType != current.runtimeType) {
      page = 0;
      update();
    }
    _lastEntite = current;
  }

  void updateFcmToken() async {
    final fcmToken = await NotificationService.getFcmToken();
    if (fcmToken != null) {
      NotificationService.onListen();
      if (user.fcmToken != fcmToken) {
        await authApi.updateFcmToken(
          fcmToken: fcmToken,
          login: user.login.value,
        );
      }
    }
  }

  @override
  void onReady() {
    _lastEntite = getEntite().value;
    // Écouter les changements d'entité
    _entiteSubscription = getEntite().listen((_) => onEntiteChanged());
    updateFcmToken();
    // Rafraîchir le compteur de notifications toutes les 2 minutes
    _notifTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      loadUnreadCount();
    });
    AppReviewService.checkForUpdate();
    super.onReady();
  }

  @override
  void onClose() {
    _entiteSubscription?.cancel();
    _notifTimer?.cancel();
    super.onClose();
  }
}
