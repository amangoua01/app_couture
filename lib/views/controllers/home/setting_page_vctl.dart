import 'package:app_couture/api/auth_api.dart';
import 'package:app_couture/tools/components/cache.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:app_couture/views/controllers/abstract/auth_view_controller.dart';
import 'package:app_couture/views/static/auth/auth_home_page.dart';
import 'package:get/get.dart';

class SettingPageVctl extends AuthViewController {
  final apiAuth = AuthApi();

  Future<void> logoutUser() async {
    final rep = await CChoiceMessageDialog.show(
      message: "Voulez-vous vraiment vous déconnecter ?",
    );
    if (rep == true) {
      final res = await apiAuth.logout().load();
      if (res.status) {
        Cache.clear();
        Get.deleteAll(force: true);
        Get.offAll(() => const AuthHomePage());
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }
}
