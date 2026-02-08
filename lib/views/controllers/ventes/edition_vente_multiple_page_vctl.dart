import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/client_api.dart';
import 'package:ateliya/data/dto/paiement_boutique/ligne_paiement_boutique_dto.dart';
import 'package:ateliya/data/dto/paiement_boutique_dto.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LignePanier {
  final ModeleBoutique modele;
  int quantite;
  double prixUnitaire;

  LignePanier({
    required this.modele,
    required this.quantite,
    required this.prixUnitaire,
  });

  double get total => quantite * prixUnitaire;
}

class EditionVenteMultiplePageVctl extends AuthViewController
    with PrinterManagerViewMixin {
  final formKeyInfo = GlobalKey<FormState>();

  final clientApi = ClientApi();
  final boutiqueApi = BoutiqueApi();

  Client? client;
  Boutique? boutique;
  final dateVenteCtl = DateTimeEditingController.dateTime(DateTime.now());
  String moyenPaiement = ModePaiementEnum.especes.label;

  final panier = <LignePanier>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (getEntite().value is Boutique) {
      boutique = getEntite().value as Boutique;
    }
  }

  Future<List<Client>> getClients() async {
    final res = await clientApi.list();
    return res.status ? res.data!.items : [];
  }

  Future<List<ModeleBoutique>> getModeles() async {
    if (boutique == null) return [];
    final res = await boutiqueApi.getModeleBoutiqueByBoutiqueId(boutique!.id!);
    return res.status ? res.data! : [];
  }

  void ajouterAuPanier(ModeleBoutique modele, int qte, double prix) {
    if (qte <= 0) return;

    final existingIndex = panier.indexWhere((p) => p.modele.id == modele.id);
    if (existingIndex != -1) {
      // On met à jour ou on additionne ?
      // Disons additionner la quantité, mais mettre à jour le prix si changé ?
      // Simplification : on écrase tout ou on ajoute.
      // Si on ajoute depuis le même écran, logique d'ajout.
      panier[existingIndex].quantite += qte;
      // panier[existingIndex].prixUnitaire = prix; // Keep or update ?
      panier.refresh();
    } else {
      panier
          .add(LignePanier(modele: modele, quantite: qte, prixUnitaire: prix));
    }
    update();
  }

  void modifierLignePanier(LignePanier ligne, int qte, double prix) {
    if (qte <= 0) {
      retirerDuPanier(ligne);
      return;
    }
    ligne.quantite = qte;
    ligne.prixUnitaire = prix;
    panier.refresh();
    update();
  }

  void retirerDuPanier(LignePanier ligne) {
    panier.remove(ligne);
    update();
  }

  double get totalGeneral => panier.fold(0.0, (sum, item) => sum + item.total);

  Future<void> submit() async {
    if (client == null) {
      CAlertDialog.show(message: "Veuillez sélectionner un client.");
      return;
    }
    if (panier.isEmpty) {
      // On pourrait autoriser vide ? Non, pas de sens.
      CAlertDialog.show(message: "Le panier est vide.");
      return;
    }

    final dto = PaiementBoutiqueDto(
      datePaiment: dateVenteCtl.dateTime!,
      clientId: client!.id!,
      boutiqueId: boutique!.id!,
      moyenPaiement: moyenPaiement,
      lignes: panier
          .map((p) => LignePaiementBoutiqueDto(
                boutiqueModeleId: p.modele.id!,
                quantite: p.quantite,
                montant: p.prixUnitaire,
              ))
          .toList(),
    );

    final res = await boutiqueApi.makePaiement(dto).load();
    if (res.status) {
      final wantPrint = await Get.defaultDialog<bool>(
        title: "Succès",
        middleText: "Vente enregistrée.\nVoulez-vous imprimer le reçu ?",
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
      Get.back(result: true);
    } else {
      CAlertDialog.show(message: res.message);
    }
  }
}
