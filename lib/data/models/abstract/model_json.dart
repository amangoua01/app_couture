import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

abstract class ModelJson<T> extends Model<T> {
  ModelJson({super.id});

  Json toJson();

  @override
  T fromJson(Json json);
}
