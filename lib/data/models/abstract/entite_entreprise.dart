import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class EntiteEntreprise extends Model {
  EntiteEntreprise({super.id});

  @override
  fromJson(Json json) {
    id = json['id'];
  }

  @override
  Map<String, dynamic> toJson() => {'id': id};

  bool get isEmpty => id == null;

  bool get isNotEmpty => !isEmpty;
}
