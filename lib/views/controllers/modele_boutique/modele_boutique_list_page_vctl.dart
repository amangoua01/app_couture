import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';

class ModeleBoutiqueListPageVctl extends ListViewController<ModeleBoutique>
    with PrinterManagerViewMixin {
  ModeleBoutiqueListPageVctl()
      : super(
          ModeleBoutiqueApi(),
          provideIdToListApi: true,
        );
}
