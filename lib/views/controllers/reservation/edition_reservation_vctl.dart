import 'package:ateliya/api/client_api.dart';
import 'package:ateliya/api/reservation_api.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/reservation.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionReservationVctl extends AuthViewController {
  final ModeleBoutique modeleBoutique;
  final _api = ReservationApi();
  final _clientApi = ClientApi();
  final formKey = GlobalKey<FormState>();

  final quantiteCtl = TextEditingController(text: '1');
  final prixCtl = TextEditingController();
  final avanceCtl = TextEditingController(text: '0');

  final dateRetraitCtl = DateTimeEditingController();
  Client? client;
  DateTime? dateRetrait;
  String moyenPaiement = ModePaiementEnum.especes.label;
  Boutique? boutique;

  EditionReservationVctl(this.modeleBoutique) {
    prixCtl.text = modeleBoutique.prix.toDouble().value.toStringAsFixed(0);
    if (getEntite().value is Boutique) {
      boutique = getEntite().value as Boutique;
    }
  }

  int get quantite => quantiteCtl.text.toInt().value;
  double get prixUnitaire => prixCtl.text.toDouble().value;
  double get montant => quantite * prixUnitaire;
  double get avance => avanceCtl.text.toDouble().value;
  double get reste => montant - avance;
  int get stock => modeleBoutique.quantite ?? 0;

  /// Le serveur accepte de réserver au-delà du stock : la réservation passe
  /// alors « en attente de stock ». On prévient simplement l'utilisateur.
  bool get stockInsuffisant => quantite > stock;

  void changeQuantite(int delta) {
    final next = (quantite + delta).clamp(1, 9999);
    quantiteCtl.text = '$next';
    update();
  }

  /// Raccourci : verser la moitié, ou tout, sans calculer de tête.
  void definirAvance(double valeur) {
    avanceCtl.text = valeur.round().toString();
    update();
  }

  List<Client>? _clients;

  Future<List<Client>> getClients() async {
    if (_clients != null) return _clients!;
    _clients = await _clientApi.listForSelect();
    return _clients!;
  }

  void onClientCreated(Client created) {
    _clients = [created, ...?_clients];
    client = created;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getClients();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (boutique?.id == null || client?.id == null || dateRetrait == null) {
      return;
    }

    final dto = ReservationDto(
      clientId: client!.id!,
      boutiqueId: boutique!.id!,
      modeleBoutiqueId: modeleBoutique.id!,
      quantite: quantite,
      montant: montant.round(),
      avance: avance.round(),
      dateRetrait: dateRetrait!,
      moyenPaiement: moyenPaiement,
    );

    final res = await _api.creer(dto).load();
    if (res.status) {
      CSnackbar.show(
        message:
            res.data?.statut.manqueDeStock == true
                ? 'Réservation enregistrée, en attente de stock'
                : 'Réservation enregistrée',
        isSuccess: true,
      );
      Get.back<Reservation>(result: res.data);
    } else {
      CMessageDialog.show(message: res.message);
    }
  }
}
