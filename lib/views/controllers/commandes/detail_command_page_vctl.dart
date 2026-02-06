import 'package:ateliya/api/mesure_api.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/pdf/command_receipt_pdf.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:get/get.dart';

class DetailCommandPageVctl extends GetxController
    with PrinterManagerViewMixin {
  final mesureApi = MesureApi();

  Future<void> printReceipt(Mesure mesure) async {
    await printMesureReceipt(mesure);
  }

  Future<void> exportPdf(Mesure mesure) async {
    await CommandReceiptPdf.generate(mesure);
  }

  Future<void> printClientMensurations(Mesure mesure) async {
    await printClientMensurationsReceipt(mesure);
  }

  Future<Mesure?> changeEtatMesure(int ligneMesureId, String nouvelEtat) async {
    final res =
        await mesureApi.changeEtatmesure(ligneMesureId, nouvelEtat).load();
    if (res.status) {
      CAlertDialog.show(
        message: "État modifié avec succès",
      );
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
      return null;
    }
  }

  Future<Mesure?> changeEtatFacture(int id, String nouvelEtat) async {
    final res = await mesureApi.changeEtatFacture(id, nouvelEtat).load();
    if (res.status) {
      CAlertDialog.show(
        message: "État de la commande modifié avec succès",
      );
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
      return null;
    }
  }
}
