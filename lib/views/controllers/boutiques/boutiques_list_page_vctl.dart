import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class BoutiquesListPageVctl extends ListViewController<Boutique> {
  BoutiquesListPageVctl() : super(BoutiqueApi(), provideIdToListApi: false);
}
