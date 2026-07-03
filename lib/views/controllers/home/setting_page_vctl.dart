import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/tools/components/cache.dart';
import 'package:ateliya/tools/constants/env.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/static/auth/auth_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPageVctl extends AuthViewController {
  final apiAuth = AuthApi();

  Future<void> logoutUser() async {
    final rep = await CChoiceMessageDialog.show(
      message: "Voulez-vous vraiment vous déconnecter ?",
    );
    if (rep == true) {
      await apiAuth.logout().load();
      Cache.clear();
      Get.deleteAll(force: true);
      Get.offAll(() => const AuthHomePage());
    }
  }

  Future<void> openPlayStore() async {
    final uri = Uri.parse(Env.playStoreUrl);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> openAppStore() async {
    final uri = Uri.parse(Env.appStoreUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> shareApp() async {
    final text = "Gérez votre atelier ou boutique facilement avec Ateliya !\n"
        "📱 Android : ${Env.playStoreUrl}\n"
        "🍎 iOS : ${Env.appStoreUrl}";
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      "Lien copié !",
      "Le lien de partage a été copié dans le presse-papiers.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF112C26),
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 3),
    );
  }
}
