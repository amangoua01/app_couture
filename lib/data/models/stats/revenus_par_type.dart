import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class RevenusParType extends ModelJson {
  String? type;
  int? revenus;

  RevenusParType({this.type, this.revenus});

  @override
  RevenusParType fromJson(Json json) {
    return RevenusParType.fromJson(json);
  }

  RevenusParType.fromJson(Json json) {
    type = json['type'];
    revenus = json['revenus'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['revenus'] = revenus;
    return data;
  }
}