import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/data/dto/update_profil_dto.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/widgets.dart';

class ProfilPageVctl extends AuthViewController {
  final nomCtl = TextEditingController();
  final prenomCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final api = AuthApi();

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      final dto = UpdateProfilDto(
        id: user.id.value,
        nom: nomCtl.text,
        prenom: prenomCtl.text,
        email: user.login.value,
      );

      final res = await api.updateProfile(dto).load();
      if (res.status) {
        user.nom = dto.nom;
        user.prenoms = dto.prenom;
        user = user;
        update();
        CAlertDialog.show(message: "Profil mis à jour avec succès");
        update();
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }

  @override
  void onInit() {
    nomCtl.text = user.nom.value;
    prenomCtl.text = user.prenoms.value;
    super.onInit();
  }
}
