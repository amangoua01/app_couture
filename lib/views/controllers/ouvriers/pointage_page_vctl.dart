import 'package:ateliya/api/employe_api.dart';
import 'package:ateliya/api/pointage_api.dart';
import 'package:ateliya/api/type_mesure_api.dart';
import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/data/models/pointage.dart';
import 'package:ateliya/data/models/pointage_ligne.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';
import 'package:ateliya/views/controllers/ouvriers/atelier_scope.dart';
import 'package:intl/intl.dart';

class PointagePageVctl extends ListViewController<Employe> {
  final _pointageApi = PointageApi();
  final _typeMesureApi = TypeMesureApi();

  String dateJour = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Map<int, Pointage> pointagesDuJour = {};
  List<TypeMesure> typesMesure = [];

  PointagePageVctl() : super(EmployeApi());

  /// On ne pointe que l'équipe de l'atelier actif : les ouvriers des autres
  /// ateliers ne travaillent pas ici et n'ont rien à faire dans cette feuille.
  @override
  Map<String, String> get extraListQuery => filtreAtelierActif(getEntite().value);

  @override
  void onReady() {
    super.onReady();
    chargerPointages();
    chargerTypesMesure();
  }

  Future<void> chargerTypesMesure() async {
    final res = await _typeMesureApi.list();
    if (res.status) {
      typesMesure = res.data!.items;
      update();
    }
  }

  Future<void> chargerPointages() async {
    final res = await _pointageApi.listForDate(dateJour);
    if (res.status) {
      pointagesDuJour.clear();
      for (final p in res.data ?? <Pointage>[]) {
        if (p.employeId != null) {
          pointagesDuJour[p.employeId!] = p;
        }
      }
      update();
    }
  }

  /// Soumission unique de toute la fiche (arrivée, départ, pièces,
  /// observation) depuis la feuille d'édition — remplace l'ancien
  /// enregistrement automatique à chaque champ.
  Future<bool> savePointage(
    Employe employe, {
    String? arrivee,
    String? depart,
    required List<PointageLigne> lignes,
    String? observation,
  }) async {
    if (employe.id == null) return false;
    final existing = pointagesDuJour[employe.id];
    final p = Pointage(
      id: existing?.id,
      employeId: employe.id,
      dateJour: dateJour,
      arrivee: arrivee,
      depart: depart,
      lignes: lignes,
      observation: observation,
    );

    final res = await _pointageApi.save(p);
    if (res.status && res.data != null) {
      pointagesDuJour[employe.id!] = res.data!;
      update();
      return true;
    } else {
      CMessageDialog.show(message: res.message);
      return false;
    }
  }
}
