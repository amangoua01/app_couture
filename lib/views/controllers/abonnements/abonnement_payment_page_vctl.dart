import 'package:ateliya/api/abonnement_api.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AbonnementPaymentPageVctl extends AuthViewController {
  final phoneCtl = TextEditingController();
  final api = AbonnementApi();
  bool isLoading = false;

  Future<void> validatePayment({
    required int forfaitId,
    required String operateur,
  }) async {
    if (phoneCtl.text.length < 8) {
      Get.snackbar(
        "Erreur",
        "Veuillez saisir un numéro de téléphone valide",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading = true;
    update();

    final res = await api.pay(
      forfaitId: forfaitId,
      email: user.login.value,
      numero: phoneCtl.text,
      operateur: operateur,
    );

    isLoading = false;
    update();

    if (res.status) {
      launchUrl(Uri.parse(res.data!));
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  @override
  void onClose() {
    phoneCtl.dispose();
    super.onClose();
  }
}
