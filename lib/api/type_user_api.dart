import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/type_user.dart';

class TypeUserApi extends CrudWebController<TypeUser> {
  @override
  TypeUser get item => TypeUser();

  @override
  String get module => "typeUser";
}
