import 'package:ateliya/api/facture_api.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/models/paginated_data.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class CommandeListVctl extends ListViewController<Mesure> {
  CommandeListVctl() : super(FactureApi());

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  Future<void> getList({int page = 1, String? search}) async {
    startLoad(page);
    final res = await (api as FactureApi).getFacturesEntreprise();

    endLoad(page);

    if (res.status) {
      if (page == 1) {
        data = PaginatedData(items: res.data ?? [], page: page);
        data.hasMore = false; // L'API retourne tout, pas de pagination
      } else {
        if (res.data != null && res.data!.isNotEmpty) {
          data.append(PaginatedData(items: res.data!, page: page));
        }
      }
      update();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }
}
