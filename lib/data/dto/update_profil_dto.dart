import 'package:ateliya/data/dto/abstract/multi_part_dto_model.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:http/http.dart' as http;

class UpdateProfilDto extends MultiPartDtoModel {
  final int id;
  final String nom;
  final String prenom;
  final FichierLocal? photoProfil;

  UpdateProfilDto({
    required this.id,
    required this.nom,
    required this.prenom,
    this.photoProfil,
  });

  @override
  Map<String, String> toJson() {
    return {'nom': nom, 'prenoms': prenom};
  }

  @override
  Future<List<http.MultipartFile>> getFiles() async {
    var files = <http.MultipartFile>[];
    if (photoProfil?.path != null) {
      files.add(await http.MultipartFile.fromPath("logo", photoProfil!.path));
    }
    return files;
  }
}
