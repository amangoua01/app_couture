import 'package:ateliya/api/personnel_api.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class PersonnelsListPageVctl extends ListViewController<User> {
  PersonnelsListPageVctl() : super(PersonnelApi());
}
