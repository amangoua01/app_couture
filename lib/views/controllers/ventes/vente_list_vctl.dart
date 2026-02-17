import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/vente.dart';
import 'package:ateliya/tools/constants/periode_vente_enum.dart';
import 'package:ateliya/tools/models/paginated_data.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';

class VenteListVctl extends ListViewController<Vente>
    with PrinterManagerViewMixin {
  VenteListVctl() : super(BoutiqueApi());

  PeriodeVenteEnum periode = PeriodeVenteEnum.aujourdhui;
  DateTime? dateDebut;
  DateTime? dateFin;

  void changePeriode(PeriodeVenteEnum p) {
    periode = p;
    update();
    getList();
  }

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  Future<void> getList({int page = 1, String? search}) async {
    startLoad(page);
    final entiteId = getEntite().value.id;
    if (entiteId == null) {
      endLoad(page);
      return;
    }

    final Map<String, dynamic> filters = {};

    filters["periode"] = periode.code;

    // Cas "Tous" -> par défaut mois en cours (selon algo serveur)
    var start = dateDebut;
    var end = dateFin;
    if (start == null || end == null) {
      final now = DateTime.now();
      start = DateTime(now.year, now.month, 1);
      end = now;
    }
    filters["date_debut"] = start.toIso8601String().split('T')[0];
    filters["date_fin"] = end.toIso8601String().split('T')[0];

    final res = await (api as BoutiqueApi).getVentes(entiteId, filters);

    endLoad(page);

    if (res.status) {
      if (page == 1) {
        data = PaginatedData(items: res.data ?? [], page: page);
        data.hasMore = false;
      } else {
        if (res.data != null && res.data!.isNotEmpty) {
          data.append(PaginatedData(items: res.data!, page: page));
        }
      }
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }
}
