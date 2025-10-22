import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/components/cache.dart';
import 'package:app_couture/tools/constants/cache_key.dart';
import 'package:get/get.dart';

abstract class SessionManagerViewController extends GetxController {
  set user(User value) {
    if (Get.isRegistered<User>()) {
      Get.replace<User>(value);
    } else {
      Get.put<User>(value, permanent: true);
    }
    update();
  }

  Future<String?> getJwtFromCache() => Cache.getString(CacheKey.jwt.name);

  static String get jwt {
    if (Get.isRegistered<String>()) {
      return Get.find<String>();
    } else {
      return "";
    }
  }

  static set jwt(String value) {
    if (Get.isRegistered<String>()) {
      Get.replace<String>(value);
    } else {
      Get.put<String>(value, permanent: true);
    }
    Cache.setString(CacheKey.jwt.name, value);
  }
}
