import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class EntiteEntreprise extends ModelJson {
  String? libelle;
  EntiteEntreprise({super.id, this.libelle});

  @override
  fromJson(Json json) {
    id = json['id'];
    libelle = json['libelle'];
  }

  @override
  Map<String, dynamic> toJson() => {'id': id, 'libelle': libelle};
  bool get isEmpty => id == null;

  bool get isNotEmpty => !isEmpty;
}
