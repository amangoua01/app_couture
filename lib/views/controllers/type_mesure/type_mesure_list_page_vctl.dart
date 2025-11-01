import 'package:app_couture/api/type_mesure_api.dart';
import 'package:app_couture/data/models/type_mesure.dart';
import 'package:app_couture/views/controllers/abstract/list_view_controller.dart';

class TypeMesureListPageVctl extends ListViewController<TypeMesure> {
  TypeMesureListPageVctl() : super(TypeMesureApi());
}