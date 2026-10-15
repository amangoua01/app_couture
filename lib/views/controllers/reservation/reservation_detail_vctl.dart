import 'package:ateliya/api/reservation_api.dart';
import 'package:ateliya/data/models/reservation.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class ReservationDetailVctl extends AuthViewController {
  final int reservationId;
  final _api = ReservationApi();

  Reservation? reservation;
  bool isLoading = true;

  /// Vrai dès qu'une action a modifié la réservation : la liste qui a ouvert
  /// cet écran doit alors se recharger à son retour.
  bool modifiee = false;

  ReservationDetailVctl(this.reservationId, {Reservation? initiale})
    : reservation = initiale;

  Future<void> charger({bool silencieux = false}) async {
    if (!silencieux && reservation == null) {
      isLoading = true;
      update();
    }
    final res = await _api.detail(reservationId);
    isLoading = false;
    if (res.status) {
      reservation = res.data;
    } else if (reservation == null) {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  Future<bool> _appliquer(
    Future<dynamic> Function() action,
    String succes,
  ) async {
    final res = await action();
    if (res.status) {
      modifiee = true;
      await charger(silencieux: true);
      CSnackbar.show(message: succes, isSuccess: true);
      return true;
    }
    CMessageDialog.show(message: res.message);
    return false;
  }

  Future<bool> verser(int montant, String moyenPaiement) => _appliquer(
    () =>
        _api
            .verser(
              reservationId,
              montant: montant,
              moyenPaiement: moyenPaiement,
            )
            .load(),
    'Versement enregistré',
  );

  Future<bool> confirmer({String? notes}) => _appliquer(
    () => _api.confirmer(reservationId, notes: notes).load(),
    'Réservation confirmée, stock mis à jour',
  );

  Future<bool> annuler({String? motif}) => _appliquer(
    () => _api.annuler(reservationId, motif: motif).load(),
    'Réservation annulée',
  );

  @override
  void onReady() {
    charger();
    super.onReady();
  }
}
