import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

abstract class ModelJson<T> extends Model<T> {
  ModelJson({super.id});

  Json toJson();

  @override
  T fromJson(Json json);
}
