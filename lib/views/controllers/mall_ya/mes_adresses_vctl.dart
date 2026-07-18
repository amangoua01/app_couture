import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/user_adresse.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class MesAdressesVctl extends AuthViewController {
  final _api = MallApi();
  List<UserAdresse> adresses = [];
  bool loading = true;

  final titreCtl = TextEditingController();
  final adresseCtl = TextEditingController();
  final villeCtl = TextEditingController();
  final telCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  @override
  void onClose() {
    titreCtl.dispose();
    adresseCtl.dispose();
    villeCtl.dispose();
    telCtl.dispose();
    super.onClose();
  }

  Future<void> _load() async {
    loading = true;
    update();
    final res = await _api.getAdresses(user.id!).load();
    if (res.status) adresses = res.data!;
    loading = false;
    update();
  }

  void _clearForm() {
    titreCtl.clear();
    adresseCtl.clear();
    villeCtl.clear();
    telCtl.clear();
  }

  Future<void> showForm({UserAdresse? item}) async {
    if (item != null) {
      titreCtl.text = item.titre;
      adresseCtl.text = item.adresse;
      villeCtl.text = item.ville;
      telCtl.text = item.telephone;
    } else {
      _clearForm();
    }
    update();
  }

  Future<void> save({UserAdresse? item}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final body = {
      'titre': titreCtl.text,
      'adresse': adresseCtl.text,
      'ville': villeCtl.text,
      'telephone': telCtl.text,
    };
    final res = item == null
        ? await _api.addAdresse(user.id!, body).load()
        : await _api.updateAdresse(item.id, body).load();
    if (res.status) {
      await CSnackbar.show(
          message: item == null ? 'Adresse ajoutée' : 'Adresse modifiée',
          isSuccess: true);
      _clearForm();
      await _load();
    } else {
      CSnackbar.show(message: res.message);
    }
  }

  Future<void> delete(UserAdresse item) async {
    final res = await _api.deleteAdresse(item.id).load();
    if (res.status) {
      adresses.remove(item);
      update();
      CSnackbar.show(message: 'Adresse supprimée', isSuccess: true);
    } else {
      CSnackbar.show(message: res.message);
    }
  }
}
