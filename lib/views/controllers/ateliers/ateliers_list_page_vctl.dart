import 'package:ateliya/api/succursale_api.dart';
import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class AteliersListPageVctl extends ListViewController<Atelier> {
  AteliersListPageVctl() : super(SuccursaleApi());
}
