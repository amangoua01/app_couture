import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/views/static/auth/auth_home_page.dart';
import 'package:app_couture/views/static/home/home_windows.dart';
import 'package:get/get.dart';

class SplashScreenPageVctl extends SessionManagerViewController {
  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    final cachedUser = await User.getUserFromCache();
    if (cachedUser != null) {
      user = cachedUser;
      Get.off(() => const HomeWindows());
    } else {
      Get.off(() => const AuthHomePage());
    }
  }

  @override
  void onInit() {
    redirect();
    super.onInit();
  }
}
