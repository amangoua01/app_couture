import 'package:app_couture/tools/extensions/types/map.dart';

abstract class Model<T> {
  int? id;

  Model({this.id});

  Map<String, dynamic> toJson();

  T fromJson(Json json);

  // @override
  // operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is Model && runtimeType == other.runtimeType && id == other.id;

  // @override
  // int get hashCode => hash2(id.hashCode, runtimeType.hashCode);
}
