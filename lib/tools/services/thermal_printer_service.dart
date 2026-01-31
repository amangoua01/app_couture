import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/ventes/edition_vente_multiple_page_vctl.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class ThermalPrinterService {
  Future<bool> checkPermission() async {
    return await PrintBluetoothThermal.isPermissionBluetoothGranted;
  }

  Future<List<BluetoothInfo>> getPairedDevices() async {
    return await PrintBluetoothThermal.pairedBluetooths;
  }

  Future<bool> connect(String mac) async {
    return await PrintBluetoothThermal.connect(macPrinterAddress: mac);
  }

  Future<bool> disconnect() async {
    return await PrintBluetoothThermal.disconnect;
  }

  Future<void> printReceipt({
    required Boutique boutique,
    required Client client,
    required List<LignePanier> items,
    required double total,
    required DateTime date,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    // Header
    bytes += generator.text(boutique.libelle.value,
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          bold: true,
        ));
    if (boutique.contact != null) {
      bytes += generator.text("Tel: ${boutique.contact}",
          styles: const PosStyles(align: PosAlign.center));
    }
    // if (boutique.adresse != null) {
    //   bytes += generator.text(boutique.adresse!,
    //       styles: const PosStyles(align: PosAlign.center));
    // }
    bytes += generator.feed(1);
    bytes += generator.hr();

    // Client
    bytes += generator.text("Client: ${client.nomComplet}",
        styles: const PosStyles(align: PosAlign.left, bold: true));
    bytes += generator.text(
        "Date: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}",
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.hr();

    // Items Header
    bytes += generator.row([
      PosColumn(text: 'Qte', width: 2, styles: const PosStyles(bold: true)),
      PosColumn(text: 'Item', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
          text: 'Total',
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    // Items List
    for (var item in items) {
      final name = item.modele.modele?.libelle ?? 'Article';
      // Basic truncation if name is too long for 58mm
      final displayName = name.length > 15 ? name.substring(0, 15) : name;

      bytes += generator.row([
        PosColumn(text: '${item.quantite}', width: 2),
        PosColumn(text: displayName, width: 6),
        PosColumn(
            text: item.total.toAmount(unit: '').replaceAll(' ', ''),
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.hr();

    // Total
    bytes += generator.text("TOTAL: ${total.toAmount(unit: 'F')}",
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          bold: true,
        ));

    bytes += generator.feed(2);
    bytes += generator.text("Merci de votre visite !",
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.feed(2);
    bytes += generator.cut();

    await PrintBluetoothThermal.writeBytes(bytes);
  }
}
