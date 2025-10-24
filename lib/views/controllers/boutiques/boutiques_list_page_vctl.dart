import 'package:app_couture/api/boutique_api.dart';
import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/views/controllers/abstract/list_view_controller.dart';

class BoutiquesListPageVctl extends ListViewController<Boutique> {
  BoutiquesListPageVctl() : super(BoutiqueApi());
}
