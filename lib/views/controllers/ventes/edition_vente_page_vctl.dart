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
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
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

  /// Clients chargés une seule fois : le sélecteur n'interroge plus le serveur
  /// à chaque ouverture.
  List<Client>? _clients;

  Future<List<Client>> getClients({bool refresh = false}) async {
    if (!refresh && _clients != null) return _clients!;
    _clients = await clientApi.listForSelect();
    return _clients!;
  }

  /// Après la création d'un client depuis l'écran : il rejoint la liste et se
  /// retrouve déjà sélectionné, sans repasser par le sélecteur.
  void onClientCreated(Client created) {
    _clients = [created, ...?_clients];
    client = created;
    update();
  }

  int get quantite => quantiteCtl.text.toInt().value;
  double get prixUnitaire => prixCtl.text.toDouble().value;
  double get total => quantite * prixUnitaire;
  int get stock => modeleBoutique.quantite ?? 0;

  /// Pas de la quantité, borné entre 1 et le stock disponible.
  void changeQuantite(int delta) {
    final next = (quantite + delta).clamp(1, stock < 1 ? 1 : stock);
    quantiteCtl.text = '$next';
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // Préchargement discret : la liste est prête avant l'ouverture du sélecteur.
    getClients();
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
      // Vérification du stock
      final qty = quantiteCtl.text.toInt().value;
      final stock = modeleBoutique.quantite ?? 0;
      if (qty > stock) {
        CMessageDialog.show(
          message: 'Stock insuffisant — disponible : $stock',
        );
        return;
      }

      final data = PaiementBoutiqueDto(
        datePaiment: dateVenteCtl.dateTime!,
        // Le client est facultatif : une vente au comptoir n'en a pas.
        clientId: client?.id,
        lignes: [
          LignePaiementBoutiqueDto(
            montant: prixCtl.text.toDouble().value,
            boutiqueModeleId: modeleBoutique.id!,
            quantite: quantiteCtl.text.toInt().value,
            // remise: ,
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
            footerMessage: user.settings?.messageFactureBoutique,
          );
        }

        Get.back(result: res.data!);
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }
}
