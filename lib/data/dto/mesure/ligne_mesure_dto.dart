import 'package:ateliya/data/dto/abstract/dto_model.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/data/dto/mesure/type_mesure_dto.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class LigneMesureDto extends DtoModel {
  String? nomClient;
  double montant, remise;
  MensurationDto? mensurationDto;
  String? pagneImagePath;
  String? modeleImagePath;
  TypeMesureDto? typeMesureDto;

  LigneMesureDto({
    this.modeleImagePath,
    this.pagneImagePath,
    this.montant = 0,
    this.remise = 0,
    this.nomClient,
    this.mensurationDto,
    this.typeMesureDto,
  });

  @override
  Map<String, dynamic> toJson() => {
        "montant": montant,
        "remise": remise,
        "nomClient": nomClient,
        "mensurationDto": mensurationDto,
        "typeMesure": typeMesureDto,
      };

  double get total => montant - remise;

  String get libelle {
    if (nomClient.value.isNotEmpty) {
      return "$nomClient • ${typeMesureDto?.libelle}";
    }
    return typeMesureDto?.libelle ?? "";
  }

  String get getCalcul {
    if (remise > 0) {
      return "${montant.toAmount()} - ${remise.toAmount()}";
    } else {
      return montant.toAmount();
    }
  }
}
