import 'package:ateliya/data/dto/abstract/dto_model.dart';
import 'package:ateliya/tools/constants/dash_filter_enum.dart';

class DashItemDto extends DtoModel {
  final DateTime dateDebut;
  final DateTime dateFin;
  final DashFilterEnum filtre;
  final String valeur;
  final int id;

  const DashItemDto({
    required this.id,
    required this.dateDebut,
    required this.dateFin,
    this.filtre = DashFilterEnum.jour,
    required this.valeur,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateDebut'] = dateDebut.toIso8601String();
    data['dateFin'] = dateFin.toIso8601String();
    data['filtre'] = filtre.name;
    data['valeur'] = valeur;
    return data;
  }
}
