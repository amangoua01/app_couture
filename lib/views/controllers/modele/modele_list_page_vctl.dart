import 'package:app_couture/api/modele_api.dart';
import 'package:app_couture/data/models/modele.dart';
import 'package:app_couture/views/controllers/abstract/list_view_controller.dart';

class ModeleListPageVctl extends ListViewController<Modele> {
  ModeleListPageVctl() : super(ModeleApi());
}
