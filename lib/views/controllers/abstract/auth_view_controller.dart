import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/data/models/entreprise_entities_response.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/components/session_manager_view_controller.dart';
import 'package:ateliya/tools/constants/cache_key.dart';
import 'package:get/get.dart';

typedef RxEntiteEntreprise = Rx<EntiteEntreprise>;

abstract class AuthViewController extends SessionManagerViewController {
  void setEntite(EntiteEntreprise value) {
    if (Get.isRegistered<RxEntiteEntreprise>(tag: CacheKey.entite.name)) {
      Get.find<RxEntiteEntreprise>(tag: CacheKey.entite.name).value = value;
    } else {
      Get.put<RxEntiteEntreprise>(Rx(value),
          tag: CacheKey.entite.name, permanent: true);
    }
    update();
  }

  RxEntiteEntreprise getEntite() {
    if (Get.isRegistered<RxEntiteEntreprise>(tag: CacheKey.entite.name)) {
      return Get.find<RxEntiteEntreprise>(tag: CacheKey.entite.name);
    } else {
      final rx = Rx(EntiteEntreprise());
      Get.put<RxEntiteEntreprise>(
        rx,
        tag: CacheKey.entite.name,
        permanent: true,
      );
      return rx;
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
