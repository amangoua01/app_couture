import 'package:app_couture/api/boutique_api.dart';
import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionBoutiquePageVctl extends GetxController {
  final nomCtl = TextEditingController();
  final contactCtl = TextEditingController();
  final situationCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final api = BoutiqueApi();

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      final boutique = Boutique(
        libelle: nomCtl.text,
        contact: contactCtl.text,
        situation: situationCtl.text,
      );
      final res = await api.create(boutique).load();
      if (res.status) {
        Get.back(result: res);
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }

  @override
  void onClose() {
    nomCtl.dispose();
    contactCtl.dispose();
    situationCtl.dispose();
    super.onClose();
  }
}
