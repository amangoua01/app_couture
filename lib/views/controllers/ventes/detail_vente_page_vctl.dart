import 'package:ateliya/data/models/vente.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';

class DetailVentePageVctl extends AuthViewController
    with PrinterManagerViewMixin {
  Future<void> printReceipt(Vente vente, String entrepriseName) async {
    await printVenteReceipt(
      vente,
      entrepriseName,
      footerMessage: user.settings?.messageFactureBoutique,
    );
  }
}
