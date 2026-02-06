import 'package:ateliya/data/models/vente.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:get/get.dart';

class DetailVentePageVctl extends GetxController with PrinterManagerViewMixin {
  Future<void> printReceipt(Vente vente) async {
    await printVenteReceipt(vente);
  }
}
