
# Intégration de l'Imprimante Thermique Bluetooth (BLE) sous Flutter

Ce guide détaille l'architecture et les codes d'implémentation pour la recherche, la connexion et l'impression thermique Bluetooth Low Energy (BLE) au format ESC/POS (58mm). Il est conçu pour servir de base de connaissances (instructions claires) à une IA pour l'intégrer dans un autre projet Flutter.

---

## 1. Dépendances requises

Ajoutez les packages suivants dans votre fichier `pubspec.yaml` :

```yaml
dependencies:
  get: ^4.7.2                        # Gestion de l'état (facultatif, adaptable)
  flutter_thermal_printer: ^1.1.0    # Utilisé pour le scan et la manipulation fine des imprimantes
  print_bluetooth_thermal: ^1.1.6    # Utilisé pour la connexion active et l'envoi de flux d'octets (bytes)
  permission_handler: ^12.0.0+1      # Gestion des permissions Bluetooth et Localisation
  image: ^4.5.4                      # Manipulation d'images (logos, redimensionnement)
  barcode: ^2.2.9                    # Génération de codes-barres (facultatif)
```

---

## 2. Structure des Données : Modèle de Périphérique

Créez un modèle pour standardiser les informations d'un périphérique bluetooth, compatible avec la sérialisation JSON pour le cache.

### `blue_device.dart`
```dart
import 'package:flutter_thermal_printer/utils/printer.dart';

class BlueDevice {
  final String name;
  final String address;
  final bool? isConnected;
  final bool _isEmpty;
  final String? connectionType;

  BlueDevice({
    required this.name,
    required this.address,
    this.isConnected,
    this.connectionType,
  }) : _isEmpty = false;

  BlueDevice.empty()
      : name = "",
        address = "",
        isConnected = false,
        connectionType = null,
        _isEmpty = true;

  BlueDevice.fromPrinter(Printer printer)
      : name = printer.name.value,
        isConnected = printer.isConnected,
        address = printer.address.value,
        connectionType = printer.connectionType?.name,
        _isEmpty = false;

  BlueDevice.fromJson(Map<String, dynamic> json)
      : name = json["name"] ?? "",
        address = json["address"] ?? "",
        isConnected = json["isConnected"] ?? false,
        connectionType = json["connectionType"],
        _isEmpty = false;

  Printer get toPrinter => Printer(
        name: name,
        address: address,
        isConnected: isConnected,
        connectionType: connectionType == 'BLE' ? ConnectionType.BLE : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "isConnected": isConnected,
        "connectionType": connectionType,
      };

  bool get isEmpty => _isEmpty;
  bool get isNoEmpty => !_isEmpty;
  bool get isBle => connectionType == 'BLE' || connectionType == null;
}
```

---

## 3. Service de Surveillance : État de la Connexion

Un service global (ici utilisant `GetxService`) permet de surveiller périodiquement l'état de la connexion avec l'imprimante sélectionnée pour réagir aux déconnexions inattendues.

### `printer_service.dart`
```dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'blue_device.dart';

class PrinterService extends GetxService {
  Timer? _statusTimer;
  final RxBool isPrinterConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatus();
    _startMonitoring();
  }

  Future<void> _checkInitialStatus() async {
    if (Get.isRegistered<BlueDevice>()) {
      if (Get.find<BlueDevice>().isNoEmpty) {
        try {
          isPrinterConnected.value = await PrintBluetoothThermal.connectionStatus;
        } catch (_) {}
      }
    }
  }

  void _startMonitoring() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (Get.isRegistered<BlueDevice>()) {
        final device = Get.find<BlueDevice>();
        if (device.isNoEmpty) {
          try {
            final isConnected = await PrintBluetoothThermal.connectionStatus;
            if (!isConnected) {
              _handleDisconnection();
            } else {
              if (!isPrinterConnected.value) isPrinterConnected.value = true;
            }
          } catch (_) {
            _handleDisconnection();
          }
        } else {
          isPrinterConnected.value = false;
        }
      } else {
        isPrinterConnected.value = false;
      }
    });
  }

  void _handleDisconnection() {
    if (Get.isRegistered<BlueDevice>()) {
      Get.delete<BlueDevice>(force: true);
      isPrinterConnected.value = false;
      // Notifier vos autres contrôleurs ici pour rafraîchir l'UI
    }
  }

  void onPrinterConnected() {
    isPrinterConnected.value = true;
    _startMonitoring();
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    super.onClose();
  }
}
```

---

## 4. Contrôleur de Scan & Connexion

Ce contrôleur gère la demande de permissions, le scan des périphériques BLE, la connexion/déconnexion, et la mise en cache de l'historique des imprimantes connectées.

### `print_list_page_vctl.dart`
```dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'blue_device.dart';
import 'printer_service.dart';

class PrintListPageVctl extends GetxController {
  final bluetoothInstance = FlutterThermalPrinter.instance;
  bool isBleTurnedOn = false;
  bool permissionIsGranted = false;
  bool _isScanning = false;
  List<Printer> oldDevices = [];

  // Propriété globale de l'imprimante active stockée dans Get
  BlueDevice get selectedPrinter {
    return Get.isRegistered<BlueDevice>() ? Get.find<BlueDevice>() : BlueDevice.empty();
  }

  set selectedPrinter(BlueDevice printer) {
    if (Get.isRegistered<BlueDevice>()) {
      printer.isEmpty ? Get.delete<BlueDevice>(force: true) : Get.replace<BlueDevice>(printer);
    } else {
      Get.put(printer, permanent: true);
    }
    if (Get.isRegistered<PrinterService>()) {
      Get.find<PrinterService>().onPrinterConnected();
    }
  }

  Future<void> checkIfBluetoothIsOn() async {
    if (_isScanning) return;
    _isScanning = true;
    try {
      final hasPerms = await _checkAndRequestPermissions();
      if (hasPerms) {
        await loadOldPrinters();
        final res = await PrintBluetoothThermal.bluetoothEnabled;
        if (res) {
          try {
            await bluetoothInstance.getPrinters(connectionTypes: [ConnectionType.BLE]);
            isBleTurnedOn = true;
          } catch (e) {
            isBleTurnedOn = false;
          }
        } else {
          isBleTurnedOn = false;
        }
        update();
      }
    } finally {
      _isScanning = false;
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      final status = await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.locationWhenInUse,
      ].request();
      permissionIsGranted = status.values.every((e) => e.isGranted);
    } else {
      permissionIsGranted = true;
    }
    update();
    return permissionIsGranted;
  }

  Future<void> onConnect(Printer printer) async {
    if (selectedPrinter.isConnected != true) {
      final res = await PrintBluetoothThermal.connect(
        macPrinterAddress: printer.address.value.toUpperCase(),
      );
      if (res) {
        selectedPrinter = BlueDevice.fromPrinter(printer);
        if (!oldDevices.any((e) => e.address == printer.address)) {
          oldDevices.add(printer);
          saveOldPrinters();
        }
        update();
      }
    } else {
      await bluetoothInstance.disconnect(printer);
      selectedPrinter = BlueDevice.empty();
      update();
    }
  }

  Future<void> loadOldPrinters() async {
    // Charger depuis le cache local (ex: SharedPreferences / Hive)
  }

  Future<void> saveOldPrinters() async {
    // Sauvegarder dans le cache local
  }
}
```

---

## 5. Génération et Envoi de Flux ESC/POS (Impression)

L'impression consiste à assembler des commandes binaires (octets/bytes) conformes au standard ESC/POS grâce au package `flutter_thermal_printer` ou directement via `print_bluetooth_thermal` en utilisant un générateur (ex: `Generator` du package `flutter_thermal_printer` ou `esc_pos_utils_plus`).

### Exemple de Mixin ou Service d'Impression : `printer_manager_view_mixin.dart`
```dart
import 'dart:convert';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'blue_device.dart';

mixin PrinterManagerMixin {
  BlueDevice get currentPrinter => Get.isRegistered<BlueDevice>() ? Get.find<BlueDevice>() : BlueDevice.empty();

  // Génération du reçu au format ESC/POS
  Future<List<int>> generateReceiptBytes({
    required String title,
    required List<Map<String, dynamic>> items,
    required double total,
    String? logoUrl,
  }) async {
    final profile = await CapabilityProfile.load();
    var generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();
    bytes += generator.setGlobalCodeTable("CP1252"); // Pour supporter les caractères accentués

    // 1. Logo
    if (logoUrl != null && logoUrl.isNotEmpty) {
      try {
        final res = await http.get(Uri.parse(logoUrl));
        if (res.statusCode == 200) {
          var image = img.decodeImage(res.bodyBytes);
          if (image != null) {
            image = img.copyResize(image, width: 100); // Redimensionner pour 58mm
            bytes += generator.image(image);
          }
        }
      } catch (_) {}
    }

    // 2. Titre
    bytes += generator.text(
      title,
      styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2, width: PosTextSize.size2),
    );
    bytes += generator.hr();

    // 3. Articles (Format Table)
    bytes += generator.row([
      PosColumn(text: "Item", width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: "Qté x Prix", width: 3, styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(text: "Total", width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    for (var item in items) {
      bytes += generator.row([
        PosColumn(text: item['name'].toString(), width: 6),
        PosColumn(text: "${item['qty']}x${item['price']}", width: 3, styles: const PosStyles(align: PosAlign.center)),
        PosColumn(text: "${item['total']}", width: 3, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += generator.hr();

    // 4. Total général
    bytes += generator.row([
      PosColumn(text: "TOTAL TTC", width: 8, styles: const PosStyles(bold: true)),
      PosColumn(text: "$total FCFA", width: 4, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    // 5. Code QR
    bytes += generator.qrcode("Facture-$title-${DateTime.now().millisecondsSinceEpoch}");
    bytes += generator.emptyLines(3); // Espacement pour la découpe manuelle

    return bytes;
  }

  // Lancement de l'impression
  Future<void> printReceipt(List<int> bytes) async {
    if (currentPrinter.isNoEmpty) {
      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected) {
        final success = await PrintBluetoothThermal.writeBytes(bytes);
        if (!success) {
          print("Erreur d'écriture sur l'imprimante.");
        }
      } else {
        print("L'imprimante n'est pas connectée activement.");
      }
    } else {
      print("Aucune imprimante configurée.");
    }
  }
}
```

---

## 6. Bonnes Pratiques & Astuces Techniques

1. **Nettoyage des chaînes (Accents/Caractères spéciaux)** :
   Les imprimantes thermiques bas de gamme ne supportent pas tous les encodages UTF-8. Il est recommandé de créer une extension de nettoyage pour retirer ou remplacer les caractères accentués (`é` -> `e`, `à` -> `a`, etc.) avant l'impression ou d'utiliser un encodage approprié comme `setGlobalCodeTable("CP1252")`.
2. **Dimensionnement des images** :
   La largeur standard d'une imprimante 58mm est d'environ 384 pixels physiques. Si vous imprimez des logos ou images, redimensionnez-les à une largeur comprise entre 100 et 180 pixels pour éviter les troncatures ou les distorsions.
3. **Ségrégation BLE vs Classic** :
   L'utilisation de `flutter_thermal_printer` pour le scan et de `print_bluetooth_thermal` pour l'envoi de flux d'octets permet de contourner les limitations de stabilité d'écriture présentes sur certains packages spécifiques lors de connexions BLE sous iOS et Android.
