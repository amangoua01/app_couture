import 'package:ateliya/api/reservation_api.dart';
import 'package:ateliya/data/models/reservation.dart';
import 'package:ateliya/tools/constants/reservation_statut.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

/// Regroupement des statuts pour l'écran : « À traiter » réunit les
/// réservations en attente et celles qui attendent du stock.
enum ReservationOnglet { aTraiter, confirmees, annulees, toutes }

class ReservationListVctl extends AuthViewController {
  final _api = ReservationApi();

  List<Reservation> _toutes = [];
  bool isLoading = false;
  bool hasLoadedOnce = false;
  ReservationOnglet onglet = ReservationOnglet.aTraiter;

  bool _dansOnglet(Reservation r, ReservationOnglet o) {
    switch (o) {
      case ReservationOnglet.aTraiter:
        return r.statut.peutConfirmer;
      case ReservationOnglet.confirmees:
        return r.statut == ReservationStatut.confirmee;
      case ReservationOnglet.annulees:
        return r.statut == ReservationStatut.annulee;
      case ReservationOnglet.toutes:
        return true;
    }
  }

  int compte(ReservationOnglet o) =>
      _toutes.where((r) => _dansOnglet(r, o)).length;

  /// Réservations à traiter dont le stock manque : c'est ce qui bloque.
  int get nbManqueStock => _toutes.where((r) => r.statut.manqueDeStock).length;

  List<Reservation> get affichees {
    final liste = _toutes.where((r) => _dansOnglet(r, onglet)).toList();
    // À traiter : les retraits les plus proches d'abord.
    if (onglet == ReservationOnglet.aTraiter) {
      liste.sort((a, b) => _date(a).compareTo(_date(b)));
    }
    return liste;
  }

  DateTime _date(Reservation r) =>
      DateTime.tryParse(r.dateRetrait ?? '') ?? DateTime(2100);

  void choisir(ReservationOnglet o) {
    if (onglet == o) return;
    onglet = o;
    update();
  }

  Future<void> fetch() async {
    final entite = getEntite().value;
    if (entite.isEmpty) return;

    // Dernière liste connue d'abord : l'écran n'attend plus le réseau pour
    // montrer quelque chose s'il a déjà été consulté.
    if (!hasLoadedOnce) {
      final cache = await _api.readCachedByBoutique(entite.id.value);
      if (cache != null) {
        _toutes = cache;
        hasLoadedOnce = true;
        if (compte(ReservationOnglet.aTraiter) == 0 && _toutes.isNotEmpty) {
          onglet = ReservationOnglet.toutes;
        }
      }
    }

    isLoading = !hasLoadedOnce;
    update();

    final res = await _api.listByBoutique(entite.id.value);
    isLoading = false;
    if (res.status) {
      _toutes = res.data!;
      hasLoadedOnce = true;
      // Rien à traiter mais des réservations existent : on ouvre l'onglet utile.
      if (compte(ReservationOnglet.aTraiter) == 0 && _toutes.isNotEmpty) {
        onglet = ReservationOnglet.toutes;
      }
    } else if (!hasLoadedOnce) {
      hasLoadedOnce = true;
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  @override
  void onReady() {
    fetch();
    super.onReady();
  }
}
