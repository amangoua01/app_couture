import 'package:app_couture/views/static/auth/auth_home_page.dart';
import 'package:get/get.dart';

class SplashScreenPageVctl extends GetxController {
  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.to(() => const AuthHomePage());
  }

  @override
  void onInit() {
    redirect();
    super.onInit();
  }
}
