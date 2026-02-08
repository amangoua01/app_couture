import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class EntiteEntreprise extends ModelJson {
  String? libelle;
  DateTime? createdAt;
  bool isActive = true;

  EntiteEntreprise({
    super.id,
    this.libelle,
    this.createdAt,
    this.isActive = true,
  });

  @override
  fromJson(Json json) {
    id = json['id'];
    libelle = json['libelle'];
    createdAt = json['createdAt'].toString().toDateTime();
    isActive = json['isActive'] ?? true;
  }

  static EntiteEntreprise fromJsonToChild(Map<String, dynamic> json) {
    if (json["boutique"] != null) {
      return Boutique.fromJson(json);
    } else {
      return Succursale.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'libelle': libelle,
        'createdAt': createdAt?.toIso8601String(),
        'isActive': isActive,
      };

  bool get isEmpty => id == null;

  bool get isNotEmpty => !isEmpty;

  EntiteEntrepriseType get type => EntiteEntrepriseType.none;
}
