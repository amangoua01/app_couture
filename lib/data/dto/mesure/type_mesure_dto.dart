import 'package:ateliya/data/dto/abstract/dto_model.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class TypeMesureDto extends DtoModel {
  int id;
  String libelle;
  List<MensurationDto> mensurations = [];

  TypeMesureDto({
    required this.id,
    required this.libelle,
    this.mensurations = const [],
  });

  TypeMesure toModel() => TypeMesure(id: id, libelle: libelle);

  static TypeMesureDto fromModel(TypeMesure model) => TypeMesureDto(
        id: model.id.value,
        libelle: model.libelle.value,
        mensurations: model.categories
            .map((e) => MensurationDto(categorieMesure: e))
            .toList(),
      );

  set model(TypeMesure model) {
    if (id != model.id) {
      mensurations = model.categories
          .map((e) => MensurationDto(categorieMesure: e))
          .toList();
    }
    id = model.id.value;
    libelle = model.libelle.value;
  }

  @override
  Map<String, dynamic> toJson() => {"id": id, "nom": libelle};

  bool get isMensurationValide =>
      mensurations.where((e) => e.isActive).every((e) => e.valeur > 0);
}
