import 'package:app_couture/api/succursale_api.dart';
import 'package:app_couture/data/models/succursale.dart';
import 'package:app_couture/views/controllers/abstract/list_view_controller.dart';

class SuccursalesListPageVctl extends ListViewController<Succursale> {
  SuccursalesListPageVctl() : super(SuccursaleApi());
}
