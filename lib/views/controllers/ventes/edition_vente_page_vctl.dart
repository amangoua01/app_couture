import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/client_api.dart';
import 'package:ateliya/data/dto/paiement_boutique/ligne_paiement_boutique_dto.dart';
import 'package:ateliya/data/dto/paiement_boutique_dto.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionVentePageVctl extends AuthViewController
    with PrinterManagerViewMixin {
  final ModeleBoutique modeleBoutique;
  final prixCtl = TextEditingController();
  final quantiteCtl = TextEditingController(text: "1");
  Client? client;
  Boutique? boutique;
  String moyenPaiement = ModePaiementEnum.especes.label;
  final dateVenteCtl = DateTimeEditingController.dateTime(DateTime.now());
  final clientApi = ClientApi();
  final boutiqueApi = BoutiqueApi();
  final formKey = GlobalKey<FormState>();

  EditionVentePageVctl(this.modeleBoutique) {
    prixCtl.text = modeleBoutique.prix.toDouble().value.toStringAsFixed(0);
    if (getEntite().value is Boutique) {
      boutique = getEntite().value as Boutique;
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
    if (formKey.currentState!.validate()) {
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
        moyenPaiement: moyenPaiement,
      );
      final res = await boutiqueApi.makePaiement(data).load();
      if (res.status) {
        final wantPrint = await Get.defaultDialog<bool>(
          title: "Succès",
          middleText:
              "Vente créée avec succès.\nVoulez-vous imprimer le reçu ?",
          textConfirm: "Oui",
          textCancel: "Non",
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );

        if (wantPrint == true && res.data != null) {
          await printVenteReceipt(
            res.data!,
            user.entreprise?.libelle ?? "Boutique",
          );
        }

        Get.back(result: res.data!);
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }
}
