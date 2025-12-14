import 'package:ateliya/data/dto/abstract/dto_model.dart';

class CreateCategorieTypeMesureDto extends DtoModel {
  final int typeMesureId;
  final List<int> categories;

  const CreateCategorieTypeMesureDto({
    required this.typeMesureId,
    required this.categories,
  });

  @override
  Map<String, dynamic> toJson() => {
        "typeMesure": typeMesureId,
        "categorieMesures": categories,
      };
}
