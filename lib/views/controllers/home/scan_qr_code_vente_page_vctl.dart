import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/mesure_api.dart';
import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/tools/extensions/future.dart';
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
      // Un échec silencieux ici (JSON inattendu, etc.) laissait avant
      // isScanning bloqué à true pour toujours : plus aucun scan suivant
      // n'était traité, et rien ne s'affichait à l'écran. Le try/catch/
      // finally garantit qu'on retombe toujours sur un état exploitable.
      var navigatedAway = false;
      try {
        // Les deux types de reçus encodent désormais un simple id
        // numérique (court, rapide à scanner) plutôt qu'une référence
        // texte potentiellement longue.
        final scannedId = code.value.trim().toInt();
        if (scannedId == null) {
          await pauseCamera();
          await CMessageDialog.show(
            message: "Ce QR code ne correspond pas à un reçu Ateliya.",
          );
          return;
        }

        if (getEntite().value is Atelier) {
          final res = await apiMesure.getOne(scannedId).load();
          if (res.status) {
            navigatedAway = true;
            if (isFromVenteAndCommande) {
              Get.off(() => DetailCommandPage(mesure: res.data!));
            } else {
              Get.back(result: res.data!);
            }
          } else {
            await pauseCamera();
            await CMessageDialog.show(message: res.message);
          }
        } else {
          final res = await api.getVenteById(scannedId).load();
          if (res.status) {
            navigatedAway = true;
            if (isFromVenteAndCommande) {
              Get.off(() => DetailVentePage(vente: res.data!));
            } else {
              Get.back(result: res.data!);
            }
          } else {
            await pauseCamera();
            await CMessageDialog.show(message: res.message);
          }
        }
      } catch (e) {
        debugPrint('Erreur lors du traitement du QR code scanné: $e');
        await pauseCamera();
        await CMessageDialog.show(
          message: "Ce QR code n'a pas pu être lu correctement.",
        );
      } finally {
        if (!navigatedAway) {
          isScanning = false;
          await resumeCamera();
        }
      }
    });
  }
}
