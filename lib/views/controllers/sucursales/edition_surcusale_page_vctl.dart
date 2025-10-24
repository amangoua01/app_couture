import 'package:app_couture/api/surcusale_api.dart';
import 'package:app_couture/data/models/surcusale.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditionSurcusalePageVctl extends GetxController {
  final libelleCtl = TextEditingController();
  final contactCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final api = SurcursaleApi();

  @override
  void onClose() {
    libelleCtl.dispose();
    contactCtl.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    if (formKey.currentState?.validate() ?? false) {
      final succ = Surcursale(
        libelle: libelleCtl.text,
        contact: contactCtl.text,
      );
      final res = await api.create(succ).load();
      if (res.status) {
        Get.back(result: res);
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }
}
