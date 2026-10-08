import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/scan_qr_code_vente_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanQrCodePage extends StatelessWidget {
  final bool isFromVenteAndCommande;
  const ScanQrCodePage({super.key, this.isFromVenteAndCommande = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ScanQrCodeVentePageVctl(isFromVenteAndCommande),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Scanner un QR Code"),
            actions: [
              IconButton(
                tooltip: "Torche",
                onPressed: ctl.toggleFlash,
                icon: Icon(
                  ctl.isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: ctl.isFlashOn ? AppColors.secondary : null,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              QRView(
                key: ctl.qrKey,
                onQRViewCreated: ctl.onQRViewCreated,
                // Ne restreindre le décodage qu'au QR code au lieu de tous
                // les formats de code-barres par défaut : moins de travail
                // par frame, donc une détection plus rapide. On NE restreint
                // plus la zone de scan native (overlay) : ce réglage a cassé
                // la détection sur le device de test (plus aucun code
                // détecté, probablement un souci d'alignement du cadre natif
                // avec l'aperçu caméra) ; le cadre ci-dessous reste purement
                // visuel.
                formatsAllowed: const [BarcodeFormat.qrcode],
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: QrScannerOverlayShape(
                        borderColor: AppColors.secondary,
                        borderRadius: 16,
                        borderLength: 28,
                        borderWidth: 6,
                        cutOutSize: 250,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
