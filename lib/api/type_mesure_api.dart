import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/type_mesure.dart';

class TypeMesureApi extends CrudWebController<TypeMesure> {
  TypeMesureApi() : super(listApi: "entreprise");
  @override
  TypeMesure get item => TypeMesure();

  @override
  String get module => "typeMesure";
}
