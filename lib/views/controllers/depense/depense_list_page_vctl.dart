import 'package:ateliya/api/depense_api.dart';
import 'package:ateliya/data/models/depense.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class DepenseListPageVctl extends ListViewController<Depense> {
  DepenseListPageVctl() : super(DepenseApi(), provideIdToListApi: false);
}
