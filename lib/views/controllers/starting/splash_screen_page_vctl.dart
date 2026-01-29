import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/components/session_manager_view_controller.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/views/static/auth/auth_home_page.dart';
import 'package:ateliya/views/static/home/home_windows.dart';
import 'package:get/get.dart';

class SplashScreenPageVctl extends SessionManagerViewController {
  Future<void> redirect() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final cachedUser = await User.getUserFromCache();
      if (cachedUser != null) {
        user = cachedUser;
        Get.off(() => const HomeWindows());
      } else {
        Get.off(() => const AuthHomePage());
      }
    } catch (e, t) {
      DataResponse.error(systemError: e, stackTrace: t);
      Get.off(() => const AuthHomePage());
    }
  }

  @override
  void onInit() {
    redirect();
    super.onInit();
  }
}
