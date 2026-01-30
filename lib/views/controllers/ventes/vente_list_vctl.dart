import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/paiement_boutique.dart';
import 'package:ateliya/tools/models/paginated_data.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class VenteListVctl extends ListViewController<PaiementBoutique> {
  VenteListVctl() : super(BoutiqueApi());

  String periode = "Aujourd'hui";
  DateTime? dateDebut;
  DateTime? dateFin;

  final List<String> periodes = [
    "Aujourd'hui",
    "7 derniers jours",
    "Tous",
  ];

  void changePeriode(String p) {
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

    if (periode == "Aujourd'hui") {
      filters["periode"] = "aujourd_hui";
    } else if (periode == "7 derniers jours") {
      filters["periode"] = "7_derniers_jours";
    } else {
      // Cas "Tous" -> par défaut mois en cours (selon algo serveur)
      var start = dateDebut;
      var end = dateFin;

      if (start == null || end == null) {
        final now = DateTime.now();
        start = DateTime(now.year, now.month, 1);
        end = now;
      }

      filters["periode"] = "personnalisee";
      filters["date_debut"] = start.toIso8601String().split('T')[0];
      filters["date_fin"] = end.toIso8601String().split('T')[0];
    }

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
      CAlertDialog.show(message: res.message);
    }
  }
}
