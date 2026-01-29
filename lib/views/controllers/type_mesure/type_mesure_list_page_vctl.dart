import 'package:ateliya/api/type_mesure_api.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class TypeMesureListPageVctl extends ListViewController<TypeMesure> {
  TypeMesureListPageVctl() : super(TypeMesureApi());
}
