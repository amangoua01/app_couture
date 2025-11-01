import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/user.dart';

class PersonnelApi extends CrudWebController<User> {
  PersonnelApi()
      : super(
          listApi: "actif/entreprise",
          createApi: "create/membre",
          updateApi: "update/membre",
        );

  @override
  User get item => User();

  @override
  String get module => 'user';
}
