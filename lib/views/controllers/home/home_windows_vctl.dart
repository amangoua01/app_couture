import 'dart:async';

import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/services/notification_service.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class HomeWindowsVctl extends AuthViewController {
  int page = 0;
  final authApi = AuthApi();
  Timer? _notifTimer;

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
    updateFcmToken();

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
