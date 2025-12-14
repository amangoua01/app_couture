import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/type_mesure.dart';

class TypeMesureApi extends CrudWebController<TypeMesure> {
  TypeMesureApi() : super(listApi: "entreprise");
  @override
  TypeMesure get item => TypeMesure();

  @override
  String get module => "typeMesure";
}
