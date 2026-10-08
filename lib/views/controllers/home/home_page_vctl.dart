import 'dart:async';

import 'package:ateliya/api/accueil_api.dart';
import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/accueil_data.dart';
import 'package:ateliya/services/sync_service.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/constants/sens_mouvement_caisse_enum.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:ateliya/views/static/caisse/approvisionner_caisse_page.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:ateliya/views/static/commandes/commande_list_page.dart';
import 'package:ateliya/views/static/depense/edition_depense_page.dart';
import 'package:ateliya/views/static/mesure/edition_mesure_page.dart'
    show EditionMesurePage;
import 'package:ateliya/views/static/transfert_stock/edition_transfert_stock_page.dart';
import 'package:ateliya/views/static/ventes/edition_vente_multiple_page.dart';
import 'package:ateliya/views/static/ventes/vente_boutique_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageVctl extends AuthViewController with PrinterManagerViewMixin {
  var data = AccueilData();
  final api = AccueilApi();
  final scrollCtl = ScrollController();
  final boutiqueApi = BoutiqueApi();
  bool presentSubscription = false;
  bool obscureBalance = true;

  void toggleObscureBalance() {
    obscureBalance = !obscureBalance;
    update();
  }

  /// Vrai tant qu'aucune réponse réseau n'est encore arrivée pour cette entité.
  bool isFirstLoad = true;

  Future<void> loadData() async {
    final entite = getEntite().value;
    loadUnreadCount();
    if (entite.isNotEmpty) {
      // Réaffiche le dernier tableau de bord connu avant l'appel réseau.
      var hasContent = !isFirstLoad;
      if (isFirstLoad) {
        final cached = await api.readCached(entite.id!, entite.type);
        if (cached != null) {
          data = cached;
          presentSubscription = cached.subscriptionExpired;
          hasContent = true;
          update();
        }
      }

      // Le voile de chargement n'a de sens que si l'écran est encore vide :
      // sinon on rafraîchit en silence sous les données déjà affichées.
      final request = api.getAccueilData(entite.id!, entite.type);
      final res = await (hasContent ? request : request.load());
      isFirstLoad = false;
      if (res.status) {
        data = res.data!;
        presentSubscription = data.subscriptionExpired;
        update();
      } else {
        if (res.detailErrors == "endSubscription") {
          // Ancien backend : l'accueil était refusé au lieu d'être signalé.
          presentSubscription = true;
          update();
        } else if (hasContent && await SyncService.isOffline()) {
          // Hors-ligne avec un tableau de bord déjà affiché (cache ou
          // chargement précédent) : pas besoin d'un message d'erreur
          // générique par-dessus des données encore valables.
        } else {
          CMessageDialog.show(message: res.message);
        }
      }
    }
  }

  goToDepense() async {
    final res = await Get.to(() => const EditionDepensePage());
    if (res != null) {
      loadData();
    }
  }

  goToMouvementCaisse(SensMouvementCaisseEnum sens) async {
    final res = await Get.to(() => ApprovisionnerCaissePage(sens: sens));
    if (res != null) {
      loadData();
    }
  }

  bool get isBoutique =>
      getEntite().value.type == EntiteEntrepriseType.boutique;

  int get activiteItemCount =>
      isBoutique ? data.meilleuresVentes.length : data.commandes.length;

  String get activiteTitle => isBoutique ? "Dernières ventes" : "Mes mesures";

  String get activiteEmptyMessage =>
      isBoutique ? "Aucune vente récente" : "Aucune mesure récente";

  IconData get activiteEmptyIcon =>
      isBoutique ? Icons.shopping_bag_outlined : Icons.straighten_rounded;

  goToActiviteList() {
    if (isBoutique) {
      Get.to(() => const VenteBoutiqueListPage());
    } else {
      Get.to(() => const CommandeListPage());
    }
  }

  goToVenteOuMesure() async {
    if (getEntite().value.type == EntiteEntrepriseType.boutique) {
      final res = await Get.to(() => const EditionVenteMultiplePage());
      if (res != null) loadData();
    } else {
      final res = await Get.to(() => const EditionMesurePage());
      if (res != null) loadData();
    }
  }

  goToClient() => Get.to(() => const EditionClientPage());

  goToTransfert() async {
    final res = await Get.to(() => const EditionTransfertStockPage());
    if (res != null) loadData();
  }

  goToMesure() async {
    final res = await Get.to(() => const EditionMesurePage());
    if (res != null) loadData();
  }

  goToVente() async {
    final res = await Get.to(() => const EditionVenteMultiplePage());
    if (res != null) loadData();
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }

  @override
  void onClose() {
    scrollCtl.dispose();
    super.onClose();
  }

  Future<void> deletePaiement(int id) async {
    final confirm = await CChoiceMessageDialog.show(
      message: "Voulez-vous vraiment supprimer cette vente ?",
      validText: "Supprimer",
      cancelText: "Annuler",
      secondaryColor: Colors.red,
    );
    if (confirm == true) {
      final res = await boutiqueApi.deletePaiement(id).load();
      if (res.status) {
        data.meilleuresVentes.removeWhere((e) => e.id == id);
        update();
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }
}
