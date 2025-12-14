import 'package:ateliya/api/modele_api.dart';
import 'package:ateliya/data/models/modele.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class ModeleListPageVctl extends ListViewController<Modele> {
  ModeleListPageVctl() : super(ModeleApi());
}
