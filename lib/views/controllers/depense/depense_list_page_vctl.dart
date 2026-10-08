import 'package:ateliya/api/depense_api.dart';
import 'package:ateliya/data/models/depense.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

enum DepenseFiltre { toutes, semaine, mois, personnel }

class DepenseListPageVctl extends ListViewController<Depense> {
  DepenseListPageVctl() : super(DepenseApi(), provideIdToListApi: false);

  DepenseFiltre filtre = DepenseFiltre.toutes;

  void setFiltre(DepenseFiltre f) {
    filtre = f;
    update();
  }

  List<Depense> get itemsFiltres {
    switch (filtre) {
      case DepenseFiltre.toutes:
        return data.items;
      case DepenseFiltre.semaine:
        final now = DateTime.now();
        final debut = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1));
        return data.items.where((d) {
          final dt = d.createdAt.toDateTime();
          return dt != null && !dt.isBefore(debut);
        }).toList();
      case DepenseFiltre.mois:
        final now = DateTime.now();
        return data.items.where((d) {
          final dt = d.createdAt.toDateTime();
          return dt != null && dt.year == now.year && dt.month == now.month;
        }).toList();
      case DepenseFiltre.personnel:
        return data.items.where((d) {
          final groupe = (d.familleDepense?.groupeDepense?.libelle ?? '').toLowerCase();
          return groupe == 'personnel';
        }).toList();
    }
  }

  double get totalFiltre => itemsFiltres.fold<double>(
        0,
        (sum, d) => sum + (double.tryParse(d.montant ?? '0') ?? 0),
      );
}
