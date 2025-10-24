import 'package:app_couture/data/models/abstract/entite_entreprise.dart';
import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/components/cache.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:app_couture/views/static/auth/auth_home_page.dart';
import 'package:get/get.dart';

abstract class AuthViewController extends SessionManagerViewController {
  set entite(EntiteEntreprise value) {
    if (Get.isRegistered<EntiteEntreprise>()) {
      Get.replace<EntiteEntreprise>(value);
    } else {
      Get.put<EntiteEntreprise>(value, permanent: true);
    }
    update();
  }

  EntiteEntreprise get entite {
    if (Get.isRegistered<EntiteEntreprise>()) {
      return Get.find<EntiteEntreprise>();
    } else {
      return EntiteEntreprise();
    }
  }

  User get user {
    if (Get.isRegistered<User>()) {
      return Get.find<User>();
    } else {
      return User();
    }
  }

  Future<void> logoutUser() async {
    final rep = await CChoiceMessageDialog.show(
      message: "Voulez-vous vraiment vous déconnecter ?",
    );
    if (rep == true) {
      Cache.clear();
      Get.deleteAll(force: true);
      Get.offAll(() => const AuthHomePage());
    }
  }

  List<EntiteEntreprise> get entites {
    if (Get.isRegistered<List<EntiteEntreprise>>()) {
      return Get.find<List<EntiteEntreprise>>();
    } else {
      return [];
    }
  }

  set entites(List<EntiteEntreprise> value) {
    if (Get.isRegistered<List<EntiteEntreprise>>()) {
      Get.replace<List<EntiteEntreprise>>(value);
    } else {
      Get.put<List<EntiteEntreprise>>(value, permanent: true);
    }
    update();
  }
}
