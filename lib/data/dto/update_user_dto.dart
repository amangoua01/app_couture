import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/type_user.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class UpdateUserDto {
  int? id;
  String nom;
  String prenoms;
  String email;
  int? atelier;
  int? boutique;
  int? type;
  String? password;

  UpdateUserDto({
    required this.nom,
    required this.prenoms,
    required this.email,
    this.atelier,
    this.boutique,
    this.type,
    this.password,
  });

  UpdateUserDto.fromUser(User user)
    : id = user.id,
      nom = user.nom.value,
      prenoms = user.prenoms.value,
      email = user.login.value,
      atelier = user.atelier?.id,
      boutique = user.boutique?.id,
      type = user.type?.id;

  User toUser() => User(
    id: id,
    nom: nom,
    prenoms: prenoms,
    login: email,
    atelier: Atelier(id: atelier),
    boutique: Boutique(id: boutique),
    type: TypeUser(id: type),
    password: password,
  );
}
