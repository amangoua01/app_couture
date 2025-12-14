import 'package:ateliya/data/dto/abstract/dto_model.dart';

class UpdateProfilDto extends DtoModel {
  final int id;
  final String nom;
  final String prenom;
  final String email;

  UpdateProfilDto({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }
}
