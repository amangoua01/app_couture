import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class PaiementFacture extends ModelJson {
  double montant = 0;
  String? reference;
  String? type;
  DateTime? createdAt;
  bool isActive = true;

  PaiementFacture({
    super.id,
    this.montant = 0,
    this.reference,
    this.type,
    this.createdAt,
    this.isActive = true,
  });

  PaiementFacture.fromJson(Json json) {
    id = json["id"];
    montant = json["montant"].toString().toDouble().value;
    reference = json["reference"];
    type = json["type"];
    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? true;
  }

  @override
  PaiementFacture fromJson(Json json) => PaiementFacture.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "montant": montant,
        "reference": reference,
        "type": type,
        "createdAt": createdAt?.toIso8601String(),
        "isActive": isActive,
      };
}
