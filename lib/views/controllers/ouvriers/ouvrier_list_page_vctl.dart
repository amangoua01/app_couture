import 'package:ateliya/api/employe_api.dart';
import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class OuvrierListPageVctl extends ListViewController<Employe> {
  OuvrierListPageVctl() : super(EmployeApi());
}
