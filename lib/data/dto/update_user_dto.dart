import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/data/models/succursale.dart';
import 'package:app_couture/data/models/type_user.dart';
import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/extensions/types/string.dart';

class UpdateUserDto {
  int? id;
  String nom;
  String prenoms;
  String email;
  int? surccursale;
  int? boutique;
  int? type;
  String? password;

  UpdateUserDto(
      {required this.nom,
      required this.prenoms,
      required this.email,
      this.surccursale,
      this.boutique,
      this.type,
      this.password});

  UpdateUserDto.fromUser(User user)
      : id = user.id,
        nom = user.nom.value,
        prenoms = user.prenoms.value,
        email = user.login.value,
        surccursale = user.succursale?.id,
        boutique = user.boutique?.id,
        type = user.type?.id;

  User toUser() => User(
        id: id,
        nom: nom,
        prenoms: prenoms,
        login: email,
        succursale: Succursale(id: surccursale),
        boutique: Boutique(id: boutique),
        type: TypeUser(id: type),
        password: password,
      );
}
