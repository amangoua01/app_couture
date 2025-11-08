import 'dart:convert';

import 'package:app_couture/data/models/abstract/fichier.dart';
import 'package:app_couture/data/models/abstract/model_json.dart';
import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/data/models/fichier_local.dart';
import 'package:app_couture/data/models/fichier_server.dart';
import 'package:app_couture/data/models/settings.dart';
import 'package:app_couture/data/models/subscriptions.dart';
import 'package:app_couture/data/models/succursale.dart';
import 'package:app_couture/data/models/type_user.dart';
import 'package:app_couture/tools/components/cache.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/tools/constants/cache_key.dart';
import 'package:app_couture/tools/constants/type_user_enum.dart';
import 'package:app_couture/tools/extensions/types/map.dart';
import 'package:app_couture/tools/extensions/types/string.dart';

class User extends ModelJson {
  String? login;
  String? nom;
  String? prenoms;
  String? fcmToken;
  TypeUser? type;
  Fichier? _logo;
  List<String>? roles;
  bool? isActive;
  int? pays;
  Boutique? boutique;
  Succursale? succursale;
  Settings? settings;
  Subscriptions? activeSubscriptions;
  String? password;

  User(
      {super.id,
      this.login,
      this.nom,
      this.prenoms,
      this.fcmToken,
      this.type,
      String? logo,
      this.roles,
      this.isActive,
      this.pays,
      this.boutique,
      this.succursale,
      this.settings,
      this.activeSubscriptions,
      this.password})
      : _logo = logo != null ? FichierLocal(path: logo) : null;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    nom = json['nom'];
    prenoms = json['prenoms'];
    fcmToken = json['fcm_token'];
    type = json['type'] != null ? TypeUser.fromJson(json['type']) : null;
    _logo = json['logo'] != null ? FichierServer.fromJson(json['logo']) : null;
    roles = json['roles'].cast<String>();
    isActive = json['is_active'];
    pays = json['pays'];
    boutique =
        json['boutique'] == null ? null : Boutique.fromJson(json['boutique']);
    succursale = json['succursale'] == null
        ? null
        : Succursale.fromJson(json['succursale']);
    settings =
        json['settings'] != null ? Settings.fromJson(json['settings']) : null;
    activeSubscriptions = json['activeSubscriptions'] != null
        ? Subscriptions.fromJson(json['activeSubscriptions'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['fcm_token'] = fcmToken;
    data['type'] = type!.id;
    data['logo'] = _logo;
    data['roles'] = roles;
    data['is_active'] = isActive;
    data['pays'] = pays;
    if (password != null) {
      data['password'] = password;
    }
    data['boutique'] = boutique?.id;
    data['succursale'] = succursale?.id;
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    if (activeSubscriptions != null) {
      data['activeSubscriptions'] = activeSubscriptions!.toJson();
    }
    return data;
  }

  @override
  User fromJson(Json json) {
    return User.fromJson(json);
  }

  TypeUserEnum get typeEnum => type?.typeEnum ?? TypeUserEnum.none;

  bool get isAdmin => typeEnum.isAdmin;

  Future<bool> saveInCache() async {
    Cache.setString(CacheKey.user.name, toJson().parseToJson());
    Cache.setString(CacheKey.jwt.name, SessionManagerViewController.jwt);
    return true;
  }

  static Future<User?> getUserFromCache() async {
    String? userString = await Cache.getString(CacheKey.user.name);
    if (userString != null && userString.isJson) {
      getJwtFromCache();
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }

  static Future<String?> getJwtFromCache() async {
    String? jwtString = await Cache.getString(CacheKey.jwt.name);
    if (jwtString != null && jwtString.isNotEmpty) {
      SessionManagerViewController.jwt = jwtString;
      return jwtString;
    }
    return null;
  }

  String? get photoProfil {
    if (_logo is FichierServer) {
      return (_logo as FichierServer).fullUrl;
    }
    return null;
  }
}
