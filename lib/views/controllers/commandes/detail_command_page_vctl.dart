import 'package:ateliya/api/mesure_api.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/pdf/command_receipt_pdf.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';

class DetailCommandPageVctl extends AuthViewController
    with PrinterManagerViewMixin {
  final mesureApi = MesureApi();

  Future<void> printReceipt(Mesure mesure) async {
    await printMesureReceipt(
      mesure,
      footerMessage: user.settings?.messageFactureAtelier,
    );
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
      CMessageDialog.show(
        message: "État modifié avec succès",
        isSuccess: true,
      );
      return res.data;
    } else {
      CMessageDialog.show(message: res.message);
      return null;
    }
  }

  Future<Mesure?> changeEtatFacture(int id, String nouvelEtat) async {
    final res = await mesureApi.changeEtatFacture(id, nouvelEtat).load();
    if (res.status) {
      CMessageDialog.show(
        message: "État de la commande modifié avec succès",
        isSuccess: true,
      );
      return res.data;
    } else {
      CMessageDialog.show(message: res.message);
      return null;
    }
  }
}
