import 'package:ateliya/api/client_api.dart';
import 'package:ateliya/api/mesure_api.dart';
import 'package:ateliya/data/dto/mesure/mesure_dto.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/tools/models/prise_mesure_step.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
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
  final dateRetraitCtl = DateTimeEditingController();
  final pageCtl = PageController();
  final avanceCtl = TextEditingController();
  final remiseGlobaleCtl = TextEditingController();
  final formKeyPaiement = GlobalKey<FormState>();

  final pages = const [
    PriseMesureStep(
      title: "Faisons connaissance",
      subtitle: "Informations personnelles",
    ),
    PriseMesureStep(
        title: "Donnez votre mesuration",
        subtitle: "Informations sur vos mesures"),
    PriseMesureStep(
      title: "Informations de paiement",
      subtitle: "Informations sur les paiements",
    ),
    PriseMesureStep(
      title: "Récapitulatif",
      subtitle: "Informations finales",
    ),
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
          if (!formKey1.currentState!.validate()) {
            return;
          }
          break;
        case 1:
          if (!mesure.isValide) {
            CAlertDialog.show(
              message: "Veuillez ajouter des pièces"
                  " et leurs mensurations pour continuer.",
            );
            return;
          } else {
            if (!mesure.isMensurationValide) {
              CAlertDialog.show(
                message: "Veuillez completer toutes "
                    "les mensurations pour continuer.",
              );
              return;
            }
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
    final res = await clientApi.list();
    if (res.status) {
      return res.data!.items;
    } else {
      return [];
    }
  }

  Future<void> submit() async {
    final res = await CChoiceMessageDialog.show(
        message: "Confirmez-vous la validation de cette mesure ?");

    if (res == true) {
      if ((getEntite().value is Succursale)) {
        mesure.client = client;
        mesure.dateRetrait = dateRetraitCtl.dateTime;
        mesure.succursale = (getEntite().value as Succursale);
        mesure.avance = avanceCtl.toDouble();
        mesure.remiseGlobale = remiseGlobaleCtl.toDouble();
        mesure.dateRetrait = dateRetraitCtl.dateTime;
        mesure.signature = await signatureCtl.toPngBytes();
        mesure.remiseGlobale = remiseGlobaleCtl.toDouble();
        mesure.avance = avanceCtl.toDouble();
        final res = await mesureApi.create(mesure).load();
        if (res.status) {
          CAlertDialog.show(
            message: "Mesure enregistrée avec succès.",
            isSuccess: true,
          );

          // Vérifier si une imprimante est disponible
          final printerAvailable = await isPrinterAvailable();

          if (printerAvailable && res.data != null) {
            // Proposer l'impression des mensurations
            final printChoice = await CChoiceMessageDialog.show(
              message:
                  "Voulez-vous imprimer les informations du client et les mensurations ?",
            );

            if (printChoice == true) {
              // Convertir le DTO en Mesure pour l'impression
              final createdMesure = res.data as Mesure;
              await printClientMensurationsReceipt(createdMesure);
            }
          }

          clearForm();
        } else {
          CAlertDialog.show(message: res.message);
        }
      } else {
        CAlertDialog.show(
          message: "Veuillez selectionner "
              "une succursale pour effectuer cette action.",
        );
      }
    }
  }

  void clearForm() {
    mesure = MesureDto();
    page = 0;
    pageCtl.jumpToPage(page);
    dateRetraitCtl.clear();
    avanceCtl.clear();
    remiseGlobaleCtl.clear();
    signatureCtl.clear();
    remiseGlobaleCtl.clear();
    client = null;
    contactClientCtl.clear();
    update();
  }
}
