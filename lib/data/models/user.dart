import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/data/models/settings.dart';
import 'package:app_couture/data/models/subscriptions.dart';
import 'package:app_couture/data/models/surcusale.dart';
import 'package:app_couture/data/models/type_user.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class User extends Model {
  String? login;
  String? nom;
  String? prenoms;
  String? fcmToken;
  TypeUser? type;
  String? logo;
  List<String>? roles;
  bool? isActive;
  int? pays;
  Boutique? boutique;
  Surcusale? succursale;
  Settings? settings;
  Subscriptions? activeSubscriptions;

  User(
      {super.id,
      this.login,
      this.nom,
      this.prenoms,
      this.fcmToken,
      this.type,
      this.logo,
      this.roles,
      this.isActive,
      this.pays,
      this.boutique,
      this.succursale,
      this.settings,
      this.activeSubscriptions});

  User.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['fcm_token'] = fcmToken;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    data['logo'] = logo;
    data['roles'] = roles;
    data['is_active'] = isActive;
    data['pays'] = pays;
    data['boutique'] = boutique;
    data['succursale'] = succursale;
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    if (activeSubscriptions != null) {
      data['activeSubscriptions'] = activeSubscriptions!.toJson();
    }
    return data;
  }

  @override
  fromJson(Json json) {
    id = json['id'];
    login = json['login'];
    nom = json['nom'];
    prenoms = json['prenoms'];
    fcmToken = json['fcm_token'];
    type = json['type'] != null ? TypeUser.fromJson(json['type']) : null;
    logo = json['logo'];
    roles = json['roles'].cast<String>();
    isActive = json['is_active'];
    pays = json['pays'];
    boutique = json['boutique'];
    succursale = json['succursale'];
    settings =
        json['settings'] != null ? Settings.fromJson(json['settings']) : null;
    activeSubscriptions = json['activeSubscriptions'] != null
        ? Subscriptions.fromJson(json['activeSubscriptions'])
        : null;
  }
}
