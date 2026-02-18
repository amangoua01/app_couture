import 'package:ateliya/tools/constants/env.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AppReviewService {
  static Future<void> checkForUpdate({bool showLoader = false}) async {
    try {
      final InStoreAppVersionCheckerResult result;
      if (showLoader) {
        result = await Env.versionChecker.checkUpdate().load();
      } else {
        result = await Env.versionChecker.checkUpdate();
      }

      if (kDebugMode) {
        print("🔍 Mise à jour dispo ? ${result.canUpdate}");
        print("📱 Version actuelle : ${result.currentVersion}");
        print("🌍 Version store : ${result.newVersion}");
        print("🔗 Lien store : ${result.appURL}");
      }

      if (result.canUpdate) {
        Get.dialog(
          AlertDialog(
            title: const Text("Une mise à jour est disponible."),
            content: Text(
                "La version ${result.newVersion.value} de l'application est disponible. Veuillez la mettre à jour pour profiter des dernières fonctionnalités."),
            actions: [
              TextButton(
                child: const Text("Plus tard"),
                onPressed: () => Get.back(),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  final url = Uri.parse(result.appURL.value);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text("Mettre à jour"),
              ),
            ],
          ),
        );
      } else {
        if (showLoader) {
          CMessageDialog.show(message: "L'application est à jour.");
        }
      }
    } catch (e) {
      CMessageDialog.show(message: "Une erreur est survenue.");
    }
  }
}
