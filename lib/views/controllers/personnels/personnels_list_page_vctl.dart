import 'package:app_couture/api/personnel_api.dart';
import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/views/controllers/abstract/list_view_controller.dart';

class PersonnelsListPageVctl extends ListViewController<User> {
  PersonnelsListPageVctl() : super(PersonnelApi());
}
