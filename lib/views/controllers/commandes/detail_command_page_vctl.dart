import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/pdf/command_receipt_pdf.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:get/get.dart';

class DetailCommandPageVctl extends GetxController
    with PrinterManagerViewMixin {
  Future<void> printReceipt(Mesure mesure) async {
    await printMesureReceipt(mesure);
  }

  Future<void> exportPdf(Mesure mesure) async {
    await CommandReceiptPdf.generate(mesure);
  }
}
