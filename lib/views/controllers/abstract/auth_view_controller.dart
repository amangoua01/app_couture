import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/data/models/entreprise_entities_response.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/components/session_manager_view_controller.dart';
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

  EntrepriseEntitiesResponse get entities {
    if (Get.isRegistered<EntrepriseEntitiesResponse>()) {
      return Get.find<EntrepriseEntitiesResponse>();
    } else {
      return EntrepriseEntitiesResponse();
    }
  }

  set entities(EntrepriseEntitiesResponse value) {
    if (Get.isRegistered<EntrepriseEntitiesResponse>()) {
      Get.replace<EntrepriseEntitiesResponse>(value);
    } else {
      Get.put<EntrepriseEntitiesResponse>(value, permanent: true);
    }
    update();
  }
}
