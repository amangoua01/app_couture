import 'package:app_couture/data/models/entreprise.dart';
import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/components/cache.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/views/static/auth/login_page.dart';
import 'package:get/get.dart';

abstract class AuthViewController extends SessionManagerViewController {
  set entreprise(Entreprise value) {
    if (Get.isRegistered<Entreprise>()) {
      Get.replace<Entreprise>(value);
    } else {
      Get.put<Entreprise>(value, permanent: true);
    }
    update();
  }

  Entreprise get entreprise => Get.find<Entreprise>();

  User get user {
    if (Get.isRegistered<User>()) {
      return Get.find<User>();
    } else {
      return User();
    }
  }

  Future<void> logoutUser() async {
    Cache.clear();
    Get.deleteAll(force: true);
    Get.offAll(() => const LoginPage());
  }

  List<Entreprise> get entreprises {
    if (Get.isRegistered<List<Entreprise>>()) {
      return Get.find<List<Entreprise>>();
    } else {
      return [];
    }
  }

  set entreprises(List<Entreprise> value) {
    if (Get.isRegistered<List<Entreprise>>()) {
      Get.replace<List<Entreprise>>(value);
    } else {
      Get.put<List<Entreprise>>(value, permanent: true);
    }
    update();
  }
}
