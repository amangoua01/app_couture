import 'dart:async';
import 'dart:convert';

import 'package:ateliya/tools/components/cache.dart';
import 'package:ateliya/tools/constants/cache_key.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/blue_device.dart';
import 'package:ateliya/tools/services/sound_service.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrintListPageVctl extends GetxController with PrinterManagerViewMixin {
  // Instance pour le SCAN (BLE Discovery)
  final _flutterPrinter = FlutterThermalPrinter.instance;

  bool isScanning = false;
  bool permissionGranted = false;
  bool bluetoothEnabled = false;

  // Imprimantes disponibles (Scan temps réel)
  List<BlueDevice> scannedDevices = [];

  // Imprimantes sauvegardées (historique)
  List<BlueDevice> oldDevices = [];

  StreamSubscription? _scanSubscription;

  @override
  void onInit() {
    super.onInit();
    initLoad();
    _initScanListener();
  }

  @override
  void onClose() {
    _scanSubscription?.cancel();
    super.onClose();
  }

  void _initScanListener() {
    // Écoute du stream de scan (FlutterDentalPrinter)
    _scanSubscription = _flutterPrinter.devicesStream.listen((printers) {
      // Conversion Printer -> BlueDevice
      scannedDevices = printers
          .map((p) => BlueDevice(
                name: p.name ?? "Inconnue",
                address: p.address ?? "",
              ))
          .where((d) => d.address.isNotEmpty) // Filtrer les vides
          .toList();
      update();
    });
  }

  Future<void> initLoad() async {
    await loadOldPrinters();
    // Verification connection existante
    final isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      // Note: Sans info locale, on ne peut pas deviner le nom de l'imprimante connectée
      // On pourrait le stocker lors de la connexion précédente
    }
    await checkPermissionsAndScan();
  }

  /// Charge les imprimantes sauvegardées
  Future<void> loadOldPrinters() async {
    final res = await Cache.getString(CacheKey.oldPrinters.name);
    if (res.isJson) {
      try {
        final List<dynamic> data = jsonDecode(res.value);
        oldDevices = data.map((e) => BlueDevice.fromJson(e)).toList();
        update();
      } catch (e) {
        print("Error decoding old printers: $e");
      }
    }
  }

  /// Sauvegarde les imprimantes utilisées
  Future<void> saveOlderPrinters() async {
    await Cache.setString(
      CacheKey.oldPrinters.name,
      jsonEncode(oldDevices.map((e) => e.toJson()).toList()),
    );
  }

  /// Vérifie et demande les permissions + Check Bluetooth status
  Future<void> checkPermissionsAndScan() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    // Check status global (simplifié)
    permissionGranted = await Permission.bluetooth.isGranted ||
        await Permission.bluetoothScan.isGranted ||
        await Permission.location.isGranted;

    // Bluetooth ON ?
    bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;
    update();

    if (bluetoothEnabled) {
      scanDevices();
    }
  }

  /// Lance le scan BLE
  Future<void> scanDevices() async {
    if (isScanning) return;
    isScanning = true;
    update();

    try {
      // Lance le scan BLE via FlutterThermalPrinter (meilleur discovery)
      await _flutterPrinter.getPrinters(connectionTypes: [ConnectionType.BLE]);

      // Fallback: Récupérer aussi les paired (si le scan BLE ne trouve rien)
      // Mais FlutterThermalPrinter le fait souvent inclure.
    } catch (e) {
      print("Scan error: $e");
    } finally {
      // Le scan continue en tâche de fond via le stream, on peut arrêter le loading spinner
      // ou laisser tourner quelques secondes.
      await Future.delayed(const Duration(seconds: 4));
      isScanning = false;
      update();
    }
  }

  /// Connecte une imprimante (Logique hybride demandée)
  Future<void> connectToPrinter(BlueDevice device) async {
    // Si déjà connecté à celle-ci -> Déconnecter
    if (selectedPrinter.isNoEmpty &&
        selectedPrinter.address == device.address) {
      await disconnect();
      return;
    }

    final confirm = await CChoiceMessageDialog.show(
      message: "Voulez-vous vous connecter à ${device.name} ?",
    );
    if (confirm != true) return;

    // Déconnexion préventive propre
    if (selectedPrinter.isNoEmpty) {
      await PrintBluetoothThermal.disconnect;
    }

    // Connexion via PrintBluetoothThermal (Le plus fiable pour ESC/POS)
    final isConnected =
        await PrintBluetoothThermal.connect(macPrinterAddress: device.address);

    if (isConnected) {
      device.isConnected = true;
      selectedPrinter = device;
      update();

      CMessageDialog.show(
        message: "Connecté avec succès à ${device.name}",
        isSuccess: true,
      );
      await SoundService.playBeep();

      // Ajout historique
      if (!oldDevices.any((d) => d.address == device.address)) {
        oldDevices.add(device);
        saveOlderPrinters();
      }
      update();
    } else {
      await SoundService.playError();
      CMessageDialog.show(
        message:
            "Échec de la connexion à ${device.name}.\nVérifiez qu'elle est allumée.",
      );
    }
  }

  /// Déconnecte
  Future<void> disconnect() async {
    final confirm = await CChoiceMessageDialog.show(
      message: "Déconnecter l'imprimante actuelle ?",
    );
    if (confirm != true) return;

    await PrintBluetoothThermal.disconnect;
    selectedPrinter = BlueDevice.empty();
    update();
  }

  Future<void> removeOldDevice(BlueDevice device) async {
    final confirm = await CChoiceMessageDialog.show(
      message: "Oublier ${device.name} ?",
    );
    if (confirm != true) return;

    oldDevices.removeWhere((d) => d.address == device.address);
    saveOlderPrinters();
    update();
  }
}
