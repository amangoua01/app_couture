import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/client_api.dart';
import 'package:ateliya/data/dto/paiement_boutique/ligne_paiement_boutique_dto.dart';
import 'package:ateliya/data/dto/paiement_boutique_dto.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionVentePageVctl extends AuthViewController {
  final ModeleBoutique modeleBoutique;
  final prixCtl = TextEditingController();
  final quantiteCtl = TextEditingController(text: "1");
  Client? client;
  Boutique? boutique;
  final dateVenteCtl = DateTimeEditingController.dateTime(DateTime.now());
  final clientApi = ClientApi();
  final boutiqueApi = BoutiqueApi();

  EditionVentePageVctl(this.modeleBoutique) {
    prixCtl.text = modeleBoutique.prix.toDouble().value.toStringAsFixed(0);
    if (setEntite is Boutique) {
      boutique = setEntite as Boutique;
    }
  }

  Future<List<Client>> getClients() async {
    final res = await clientApi.list();
    if (res.status) {
      return res.data!.items;
    } else {
      return [];
    }
  }

  Future<List<Boutique>> getBoutique() async {
    final res = await boutiqueApi.list();
    if (res.status) {
      return res.data!.items;
    } else {
      return [];
    }
  }

  Future<void> submit() async {
    if (boutique != null) {
      final data = PaiementBoutiqueDto(
        datePaiment: dateVenteCtl.dateTime!,
        clientId: client!.id!,
        lignes: [
          LignePaiementBoutiqueDto(
            montant: prixCtl.text.toDouble().value,
            boutiqueModeleId: modeleBoutique.id!,
            quantite: quantiteCtl.text.toInt().value,
          ),
        ],
        boutiqueId: boutique!.id!,
      );
      final res = await boutiqueApi.makePaiement(data).load();
      if (res.status) {
        await CAlertDialog.show(message: "Vente créée avec succès !");
        Get.back(result: res.data!);
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }
}
