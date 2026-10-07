import 'package:ateliya/api/client_api.dart';
import 'package:ateliya/api/mesure_api.dart';
import 'package:ateliya/data/dto/mesure/mesure_dto.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/tools/models/prise_mesure_step.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class EditionMesurePageVctl extends AuthViewController
    with PrinterManagerViewMixin {
  int page = 0;
  final signatureCtl = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    strokeCap: StrokeCap.round,
    exportBackgroundColor: Colors.blue,
  );

  /// Délai de retrait proposé par défaut, à défaut d'une date saisie.
  static DateTime get _defaultDateRetrait =>
      DateTime.now().add(const Duration(days: 7));

  final dateRetraitCtl = DateTimeEditingController.dateTime(
    _defaultDateRetrait,
  );
  final pageCtl = PageController();
  final avanceCtl = TextEditingController();
  final remiseGlobaleCtl = TextEditingController();
  final formKeyPaiement = GlobalKey<FormState>();

  final pages = const [
    PriseMesureStep(
      title: "Donnez votre mesuration",
      subtitle: "Informations sur vos mesures",
    ),
    PriseMesureStep(
      title: "Faisons connaissance",
      subtitle: "Informations personnelles",
    ),
    PriseMesureStep(
      title: "Informations de paiement",
      subtitle: "Informations sur les paiements",
    ),
    PriseMesureStep(title: "Récapitulatif", subtitle: "Informations finales"),
  ];

  var mesure = MesureDto();

  Client? client;
  final clientApi = ClientApi();
  final formKey1 = GlobalKey<FormState>();
  final contactClientCtl = TextEditingController();
  final mesureApi = MesureApi();

  void nextPage() {
    if (page < pages.length - 1) {
      switch (page) {
        case 0:
          if (!mesure.isValide) {
            CMessageDialog.show(
              message:
                  "Veuillez ajouter des pièces"
                  " et leurs mensurations pour continuer.",
            );
            return;
          } else {
            if (!mesure.isMensurationValide) {
              CMessageDialog.show(
                message:
                    "Veuillez completer toutes "
                    "les mensurations pour continuer.",
              );
              return;
            }
          }

          break;
        case 1:
          if (!formKey1.currentState!.validate()) {
            return;
          }
          break;
        case 2:
          if (!formKeyPaiement.currentState!.validate()) {
            return;
          }
          break;
        default:
      }
      page++;
      pageCtl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    } else {
      submit();
    }
  }

  void previousPage() {
    if (page > 0) {
      page--;
      pageCtl.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  Future<List<Client>> fetchClients() async {
    // Affiche la dernière liste connue le temps que le réseau réponde, pour
    // ne pas bloquer la saisie sur un aller-retour réseau à chaque pièce.
    final cached = await clientApi.readCachedList();
    if (cached != null && cached.isNotEmpty) {
      return cached.items;
    }
    final res = await clientApi.list(useCache: true);
    if (res.status) {
      return res.data!.items;
    } else {
      return [];
    }
  }

  Future<void> submit() async {
    final res = await CChoiceMessageDialog.show(
      message: "Confirmez-vous la validation de cette mesure ?",
    );

    if (res == true) {
      if ((getEntite().value is Atelier)) {
        mesure.client = client;
        mesure.dateRetrait = dateRetraitCtl.dateTime;
        mesure.succursale = (getEntite().value as Atelier);
        mesure.avance = avanceCtl.toDouble();
        mesure.remiseGlobale = remiseGlobaleCtl.toDouble();
        mesure.dateRetrait = dateRetraitCtl.dateTime;
        mesure.signature = await signatureCtl.toPngBytes();

        final response = await mesureApi.create(mesure).load();
        if (response.status) {
          // Vérifier si une imprimante est disponible
          final printerAvailable = await isPrinterAvailable();

          if (printerAvailable && response.data != null) {
            // Proposer l'impression du reçu
            final printChoice = await CChoiceMessageDialog.show(
              title: "Succès",
              message: "Mesure enregistrée.\nVoulez-vous imprimer le reçu ?",
            );

            if (printChoice == true) {
              if (response.data is Mesure) {
                await printMesureReceipt(
                  response.data as Mesure,
                  footerMessage: user.settings?.messageFactureAtelier,
                );
              }
            }
          } else {
            CMessageDialog.show(
              message: "Mesure enregistrée avec succès.",
              isSuccess: true,
            );
          }

          clearForm();
        } else {
          CMessageDialog.show(message: response.message);
        }
      } else {
        CMessageDialog.show(
          message:
              "Veuillez selectionner "
              "une succursale pour effectuer cette action.",
        );
      }
    }
  }

  void clearForm() {
    mesure = MesureDto();
    page = 0;
    pageCtl.jumpToPage(page);
    dateRetraitCtl.dateTime = _defaultDateRetrait;
    avanceCtl.clear();
    remiseGlobaleCtl.clear();
    signatureCtl.clear();
    remiseGlobaleCtl.clear();
    client = null;
    contactClientCtl.clear();
    update();
  }
}
