import 'package:app_couture/api/boutique_api.dart';
import 'package:app_couture/api/personnel_api.dart';
import 'package:app_couture/api/surcusale_api.dart';
import 'package:app_couture/api/type_user_api.dart';
import 'package:app_couture/data/dto/update_user_dto.dart';
import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/data/models/succursale.dart';
import 'package:app_couture/data/models/type_user.dart';
import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/cupertino.dart';

class EditionPersonnelPageVctl
    extends EditionViewController<User, PersonnelApi> {
  final nomCtl = TextEditingController();
  final prenomCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final confirmPasswordCtl = TextEditingController();
  TypeUser? typeUser;
  Boutique? boutique;
  Succursale? succursale;
  final typeUserApi = TypeUserApi();
  final boutiqueApi = BoutiqueApi();
  final succursaleApi = SuccursaleApi();

  EditionPersonnelPageVctl(super.item) : super(api: PersonnelApi());

  @override
  Future<User?> onCreate() async {
    final data = UpdateUserDto(
      nom: nomCtl.text,
      prenoms: prenomCtl.text,
      email: emailCtl.text,
      type: typeUser?.id,
      boutique: boutique?.id,
      surccursale: succursale?.id,
      password: passwordCtl.text,
    );
    final res = await api.create(data.toUser()).load();
    if (res.status) {
      return res.data!;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  @override
  void onInitForm(User item) {
    nomCtl.text = item.nom.value;
    prenomCtl.text = item.prenoms.value;
    typeUser = item.type;
    boutique = item.boutique;
  }

  @override
  Future<User?> onUpdate(User item) async {
    final data = UpdateUserDto.fromUser(item);
    data.nom = nomCtl.text;
    data.prenoms = prenomCtl.text;
    data.type = typeUser?.id;
    data.boutique = boutique?.id;
    final res = await api.update(data.toUser()).load();
    if (res.status) {
      return res.data!;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  Future<List<TypeUser>> getTypeUsers() async {
    final res = await typeUserApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  Future<List<Boutique>> getBoutiques() async {
    final res = await boutiqueApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  Future<List<Succursale>> getSuccursales() async {
    final res = await succursaleApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }
}
