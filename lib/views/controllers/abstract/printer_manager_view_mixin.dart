import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/data/models/paiement_facture.dart';
import 'package:ateliya/data/models/vente.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/blue_device.dart';
import 'package:ateliya/tools/services/sound_service.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

mixin PrinterManagerViewMixin {
  /// Gestionnaire d'instance globale de l'imprimante
  BlueDevice get selectedPrinter {
    if (Get.isRegistered<BlueDevice>()) {
      return Get.find<BlueDevice>();
    } else {
      return BlueDevice.empty();
    }
  }

  set selectedPrinter(BlueDevice printer) {
    if (Get.isRegistered<BlueDevice>()) {
      Get.replace<BlueDevice>(printer);
    } else {
      Get.put(printer, permanent: true);
    }
  }

  /// Imprimer le reçu d'une mesure/commande
  Future<void> printMesureReceipt(Mesure mesure) async {
    await _printGenericReceipt(() => _generateMesureBytes(mesure));
  }

  /// Imprimer le reçu d'une vente (Boutique)
  Future<void> printVenteReceipt(Vente vente) async {
    await _printGenericReceipt(() => _generateVenteBytes(vente));
  }

  /// Imprimer le reçu d'un paiement spécifique
  Future<void> printPaiementReceipt(
      Mesure mesure, PaiementFacture paiement) async {
    await _printGenericReceipt(() => _generatePaiementBytes(mesure, paiement));
  }

  /// Imprimer les informations client et mensurations
  Future<void> printClientMensurationsReceipt(Mesure mesure) async {
    await _printGenericReceipt(() => _generateClientMensurationsBytes(mesure));
  }

  /// Vérifier si une imprimante est disponible et connectée
  Future<bool> isPrinterAvailable() async {
    try {
      if (selectedPrinter.isNoEmpty) {
        final bool isConnected = await PrintBluetoothThermal.connectionStatus;
        return isConnected;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _printGenericReceipt(
      Future<List<int>?> Function() generatorFn) async {
    try {
      if (selectedPrinter.isNoEmpty) {
        final bool isConnected = await PrintBluetoothThermal.connectionStatus;
        if (isConnected) {
          final List<int>? bytes = await generatorFn();
          if (bytes != null) {
            final res = await PrintBluetoothThermal.writeBytes(bytes);
            if (!res) {
              CAlertDialog.show(
                  message:
                      "Erreur lors de l'envoi des données à l'imprimante.");
            } else {
              SoundService.playBeep();
            }
          } else {
            CAlertDialog.show(message: "Erreur de génération du ticket.");
          }
        } else {
          _promptConnection();
        }
      } else {
        _promptConnection();
      }
    } catch (e, st) {
      debugPrint("Print Error: $e\n$st");
      CAlertDialog.show(message: "Erreur d'impression: $e");
    }
  }

  void _promptConnection() {
    CAlertDialog.show(
      message: "Aucune imprimante connectée. Veuillez en sélectionner une.",
      onConfirm: () => Get.to(() => const PrintListPage()),
    );
  }

  String _normalize(String text) {
    if (text.isEmpty) return text;
    // Replace non-breaking spaces and other common currency format chars
    return text
        .replaceAll('\u00A0', ' ')
        .replaceAll('\u202F', ' ')
        .replaceAll(' ', ' ');
  }

  Future<List<int>?> _generateMesureBytes(Mesure mesure) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();
    bytes += generator.setGlobalCodeTable('CP1252');

    // -- Header --
    if (mesure.succursale != null) {
      bytes += generator.text(
          _normalize(mesure.succursale?.libelle ?? "Atelier"),
          styles: const PosStyles(
              align: PosAlign.center,
              bold: true,
              height: PosTextSize.size2,
              width: PosTextSize.size2));
      if (mesure.succursale?.contact != null) {
        bytes += generator.text(
            _normalize("Tel: ${mesure.succursale!.contact}"),
            styles: const PosStyles(align: PosAlign.center));
      }
    }
    bytes += generator.hr();

    // -- Receipt Details --
    bytes += generator.row([
      PosColumn(text: "N° Reçu", width: 4),
      PosColumn(
        text: _normalize(mesure.id.toString()),
        width: 8,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    final dateStr = mesure.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(mesure.createdAt!)
        : "--/--/----";
    bytes += generator.row([
      PosColumn(text: "Date", width: 4),
      PosColumn(
        text: dateStr,
        width: 8,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    if (mesure.client != null) {
      bytes += generator.row([
        PosColumn(text: "Client", width: 4),
        PosColumn(
          text: _normalize(mesure.client!.fullName),
          width: 8,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
      if (mesure.client!.tel != null) {
        bytes += generator.text(_normalize("Tel: ${mesure.client!.tel}"),
            styles: const PosStyles(align: PosAlign.right));
      }
    }
    bytes += generator.hr();

    // -- Items --
    bytes += generator.row([
      PosColumn(
          text: "Article",
          width: 5,
          styles: const PosStyles(bold: true, underline: true)),
      PosColumn(
          text: "Prix",
          width: 3,
          styles: const PosStyles(
              align: PosAlign.center, bold: true, underline: true)),
      PosColumn(
          text: "Total",
          width: 4,
          styles: const PosStyles(
              align: PosAlign.right, bold: true, underline: true)),
    ]);

    for (var item in mesure.lignesMesures) {
      bytes += generator.row([
        PosColumn(
            text: _normalize(item.typeMesure?.libelle?.value ?? "Article"),
            width: 5),
        PosColumn(
            text: _normalize(item.montant.toInt().toString()),
            width: 3,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
            text: _normalize(item.total.toInt().toString()),
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += generator.emptyLines(1);
    bytes += generator.hr();

    // -- Financials --
    // Total
    bytes += generator.row([
      PosColumn(
        text: "Total TTC",
        width: 8,
        styles: const PosStyles(underline: true, bold: true),
      ),
      PosColumn(
        text: _normalize(mesure.montantTotal.toAmount(unit: "F")),
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    // Avance
    bytes += generator.row([
      PosColumn(
        text: "Avance",
        width: 8,
        styles: const PosStyles(underline: true),
      ),
      PosColumn(
        text: _normalize(mesure.avance.toAmount(unit: "F")),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    // Reste
    bytes += generator.row([
      PosColumn(
        text: "Reste à payer",
        width: 8,
        styles: const PosStyles(underline: true, bold: true),
      ),
      PosColumn(
        text: _normalize(mesure.resteArgent.toAmount(unit: "F")),
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.hr();

    // -- Footer --
    if (mesure.id != null) {
      bytes += generator.qrcode(mesure.id.toString(), size: QRSize.size4);
    }
    bytes += generator.emptyLines(1);
    bytes += generator.text("Merci de votre confiance !",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.emptyLines(3);

    return bytes;
  }

  Future<List<int>?> _generateVenteBytes(Vente vente) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();
    bytes += generator.setGlobalCodeTable('CP1252');

    bytes += generator.text("BOUTIQUE",
        styles: const PosStyles(
            align: PosAlign.center, bold: true, height: PosTextSize.size2));
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: "Ref:", width: 4),
      PosColumn(
        text: _normalize(vente.reference ?? "-"),
        width: 8,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    final dateStr =
        vente.createdAt != null ? _normalize(vente.createdAt!) : "--/--/----";
    bytes += generator.row([
      PosColumn(text: "Date", width: 4),
      PosColumn(
        text: dateStr,
        width: 8,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    if (vente.client != null) {
      bytes += generator.row([
        PosColumn(text: "Client", width: 4),
        PosColumn(
          text: _normalize(vente.client!.fullName),
          width: 8,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: "Article",
          width: 5,
          styles: const PosStyles(bold: true, underline: true)),
      PosColumn(
          text: "Qt",
          width: 2,
          styles: const PosStyles(
              align: PosAlign.center, bold: true, underline: true)),
      PosColumn(
          text: "Total",
          width: 5,
          styles: const PosStyles(
              align: PosAlign.right, bold: true, underline: true)),
    ]);

    for (var item in vente.paiementBoutiqueLignes) {
      bytes += generator.row([
        PosColumn(
            text: _normalize(item.modeleBoutique?.modele?.libelle ?? "Article"),
            width: 5),
        PosColumn(
            text: item.quantite?.toString() ?? "1",
            width: 2,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
            text: _normalize((item.total).toInt().toString()),
            width: 5,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
        text: "Total",
        width: 8,
        styles: const PosStyles(underline: true, bold: true),
      ),
      PosColumn(
        text: _normalize((vente.montant ?? 0).toAmount(unit: "F")),
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.emptyLines(1);
    bytes += generator.text("Merci de votre visite !",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.emptyLines(3);

    return bytes;
  }

  Future<List<int>?> _generatePaiementBytes(
      Mesure mesure, PaiementFacture paiement) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();
    bytes += generator.setGlobalCodeTable('CP1252');

    if (mesure.succursale != null) {
      bytes += generator.text(
          _normalize(mesure.succursale?.libelle ?? "Atelier"),
          styles: const PosStyles(
              align: PosAlign.center, bold: true, height: PosTextSize.size2));
    }
    bytes += generator.text("RECU DE PAIEMENT",
        styles: const PosStyles(align: PosAlign.center, underline: true));
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: "Cmd N°", width: 4),
      PosColumn(
        text: _normalize(mesure.id.toString()),
        width: 8,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.row([
      PosColumn(text: "Ref Paie", width: 5),
      PosColumn(
        text: _normalize(paiement.reference ?? "-"),
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    final dateStr = paiement.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(paiement.createdAt!)
        : "--/--/----";
    bytes += generator.text("Date: $dateStr");

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
        text: "Montant Versé",
        width: 8,
        styles: const PosStyles(bold: true, height: PosTextSize.size2),
      ),
      PosColumn(
        text: _normalize(paiement.montant.toAmount(unit: "F")),
        width: 4,
        styles: const PosStyles(
            align: PosAlign.right, bold: true, height: PosTextSize.size2),
      ),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: "Déjà payé", width: 6),
      PosColumn(
          text: _normalize(mesure.avance.toAmount(unit: "F")),
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: "Reste dû", width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
          text: _normalize(mesure.resteArgent.toAmount(unit: "F")),
          width: 6,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    bytes += generator.emptyLines(1);
    bytes += generator.text("Merci !",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.emptyLines(3);

    return bytes;
  }

  Future<List<int>?> _generateClientMensurationsBytes(Mesure mesure) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();
    bytes += generator.setGlobalCodeTable('CP1252');

    // -- Header --
    bytes += generator.text("FICHE CLIENT",
        styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    bytes += generator.hr();

    // -- Client Info --
    if (mesure.client != null) {
      bytes += generator.text("INFORMATIONS CLIENT",
          styles: const PosStyles(bold: true, underline: true));
      bytes += generator.emptyLines(1);

      bytes += generator.row([
        PosColumn(text: "Nom", width: 4, styles: const PosStyles(bold: true)),
        PosColumn(
          text: _normalize(mesure.client!.fullName),
          width: 8,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      if (mesure.client!.tel != null) {
        bytes += generator.row([
          PosColumn(text: "Tel", width: 4, styles: const PosStyles(bold: true)),
          PosColumn(
            text: _normalize(mesure.client!.tel!),
            width: 8,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }

      bytes += generator.hr();
    }

    // -- Mensurations par article --
    bytes += generator.text("MENSURATIONS",
        styles: const PosStyles(bold: true, underline: true));
    bytes += generator.emptyLines(1);

    for (var ligneMesure in mesure.lignesMesures) {
      if (ligneMesure.mensurations.isNotEmpty) {
        // Nom de l'article
        bytes += generator.text(
            _normalize(ligneMesure.typeMesure?.libelle?.value ?? "Article"),
            styles: const PosStyles(bold: true, height: PosTextSize.size2));
        bytes += generator.emptyLines(1);

        // Liste des mensurations
        for (var mensuration in ligneMesure.mensurations) {
          if (mensuration.isActive) {
            bytes += generator.row([
              PosColumn(
                text: _normalize(
                    mensuration.categorieMesure?.libelle ?? "Mesure"),
                width: 7,
              ),
              PosColumn(
                text: "${mensuration.taille.toStringAsFixed(1)} cm",
                width: 5,
                styles: const PosStyles(align: PosAlign.right, bold: true),
              ),
            ]);
          }
        }

        bytes += generator.emptyLines(1);
        bytes += generator.hr();
      }
    }

    // -- Footer --
    bytes += generator.emptyLines(1);
    final dateStr = mesure.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(mesure.createdAt!)
        : "--/--/----";
    bytes += generator.text("Date: $dateStr",
        styles: const PosStyles(align: PosAlign.center));

    if (mesure.id != null) {
      bytes += generator.text("Commande N°${mesure.id}",
          styles: const PosStyles(align: PosAlign.center));
    }

    bytes += generator.emptyLines(3);

    return bytes;
  }
}
