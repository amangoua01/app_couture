import 'package:ateliya/api/employe_api.dart';
import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';
import 'package:ateliya/views/controllers/ouvriers/atelier_scope.dart';

class OuvrierListPageVctl extends ListViewController<Employe> {
  OuvrierListPageVctl() : super(EmployeApi());

  /// Seuls les ouvriers de l'atelier actif sont listés : ils y sont rattachés,
  /// et mélanger les équipes de plusieurs ateliers n'a pas de sens à l'usage.
  @override
  Map<String, String> get extraListQuery => filtreAtelierActif(getEntite().value);
}
