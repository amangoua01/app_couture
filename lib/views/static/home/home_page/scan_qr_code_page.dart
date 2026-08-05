import 'package:ateliya/views/controllers/home/scan_qr_code_vente_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class ScanQrCodePage extends StatelessWidget {
  final bool isFromVenteAndCommande;
  const ScanQrCodePage({super.key, this.isFromVenteAndCommande = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ScanQrCodeVentePageVctl(isFromVenteAndCommande),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Scanner un QR Code")),
          body: Stack(
            children: [
              QRView(
                key: ctl.qrKey,
                onQRViewCreated: ctl.onQRViewCreated,
              ),
              Center(
                child: QRScannerOverlay(
                  scanAreaWidth: 250,
                  scanAreaHeight: 250,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
