import 'package:ateliya/api/succursale_api.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class SuccursalesListPageVctl extends ListViewController<Succursale> {
  SuccursalesListPageVctl() : super(SuccursaleApi());
}
