import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/mesure_api.dart';
import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/static/commandes/detail_command_page.dart';
import 'package:ateliya/views/static/ventes/detail_vente_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanQrCodeVentePageVctl extends AuthViewController {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final api = BoutiqueApi();
  final apiMesure = MesureApi();
  final bool isFromVenteAndCommande;
  bool isScanning = false;

  ScanQrCodeVentePageVctl(this.isFromVenteAndCommande);

  Future<void> pauseCamera() async {
    try {
      await controller?.pauseCamera();
    } catch (e) {
      debugPrint('Error pausing camera: $e');
    }
  }

  Future<void> resumeCamera() async {
    try {
      await controller?.resumeCamera();
    } catch (e) {
      debugPrint('Error resuming camera: $e');
    }
  }

  void onQRViewCreated(QRViewController controller) {
    if (this.controller == null) {
      this.controller = controller;
    }
    controller.scannedDataStream.listen((scanData) async {
      if (isScanning) return;
      final code = scanData.code;
      if (code == null || code.value.isEmpty) return;

      isScanning = true;
      final codeVal = code.value.trim();
      if (getEntite().value is Atelier) {
        final res = await apiMesure.getOne(codeVal.toInt().value).load();
        if (res.status) {
          if (isFromVenteAndCommande) {
            Get.off(() => DetailCommandPage(mesure: res.data!));
          } else {
            Get.back(result: res.data!);
          }
        } else {
          await pauseCamera();
          await CMessageDialog.show(message: res.message);
          isScanning = false;
          await resumeCamera();
        }
      } else {
        final res = await api.getVenteByRef(codeVal).load();
        if (res.status) {
          if (isFromVenteAndCommande) {
            Get.off(() => DetailVentePage(vente: res.data!));
          } else {
            Get.back(result: res.data!);
          }
        } else {
          await pauseCamera();
          await CMessageDialog.show(message: res.message);
          isScanning = false;
          await resumeCamera();
        }
      }
    });
  }
}
