import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/services/notification_service.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class HomeWindowsVctl extends AuthViewController {
  int page = 0;
  final authApi = AuthApi();

  void updateFcmToken() async {
    final fcmToken = await NotificationService.getFcmToken();
    if (fcmToken != null && user.fcmToken != fcmToken) {
      await authApi.updateFcmToken(
        fcmToken: fcmToken,
        login: user.login.value,
      );
    }
  }

  @override
  void onReady() {
    updateFcmToken();
    super.onReady();
  }
}
