import 'dart:async';

import 'package:ateliya/tools/models/blue_device.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

/// Service global de surveillance de la connexion imprimante thermique BLE.
///
/// Vérifie périodiquement l'état de la connexion et tente une reconnexion
/// automatique en cas de déconnexion inattendue.
class PrinterConnectionService extends GetxService {
  Timer? _statusTimer;

  /// État réactif de la connexion, observable depuis l'UI.
  final RxBool isPrinterConnected = false.obs;

  /// Nombre max de tentatives de reconnexion automatique avant abandon.
  static const int _maxReconnectAttempts = 1;

  /// Intervalle de vérification de l'état de la connexion.
  static const Duration _monitorInterval = Duration(seconds: 12);

  /// Indique si une reconnexion est en cours (éviter les doublons).
  bool _isReconnecting = false;

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatus();
    _startMonitoring();
  }

  /// Vérifie l'état de connexion au démarrage du service.
  Future<void> _checkInitialStatus() async {
    final device = _currentDevice;
    if (device != null && device.isNoEmpty) {
      try {
        isPrinterConnected.value =
            await PrintBluetoothThermal.connectionStatus;
      } catch (e) {
        debugPrint("PrinterConnectionService: initial check error: $e");
        isPrinterConnected.value = false;
      }
    }
  }

  /// Démarre (ou redémarre) le timer de surveillance périodique.
  void _startMonitoring() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(_monitorInterval, (_) => _pollStatus());
  }

  /// Vérifie l'état actuel et réagit en conséquence.
  Future<void> _pollStatus() async {
    final device = _currentDevice;

    if (device == null || device.isEmpty) {
      // Pas d'imprimante configurée
      if (isPrinterConnected.value) {
        isPrinterConnected.value = false;
      }
      return;
    }

    try {
      final isConnected = await PrintBluetoothThermal.connectionStatus;

      if (isConnected) {
        if (!isPrinterConnected.value) {
          isPrinterConnected.value = true;
        }
      } else {
        // Déconnexion détectée → tenter reconnexion
        await _handleDisconnection(device);
      }
    } catch (e) {
      debugPrint("PrinterConnectionService: poll error: $e");
      await _handleDisconnection(device);
    }
  }

  /// Gère une déconnexion : tente une reconnexion automatique, puis abandonne.
  Future<void> _handleDisconnection(BlueDevice device) async {
    if (_isReconnecting) return;
    _isReconnecting = true;

    try {
      debugPrint(
          "PrinterConnectionService: déconnexion détectée, tentative de reconnexion à ${device.address}...");

      for (int attempt = 0; attempt < _maxReconnectAttempts; attempt++) {
        // Petit délai avant la tentative pour laisser le BLE se stabiliser
        await Future.delayed(const Duration(milliseconds: 800));

        try {
          final reconnected = await PrintBluetoothThermal.connect(
            macPrinterAddress: device.address,
          );

          if (reconnected) {
            debugPrint(
                "PrinterConnectionService: reconnexion réussie (tentative ${attempt + 1})");
            isPrinterConnected.value = true;
            return;
          }
        } catch (e) {
          debugPrint(
              "PrinterConnectionService: reconnexion échouée (tentative ${attempt + 1}): $e");
        }
      }

      // Toutes les tentatives ont échoué → déconnexion définitive
      debugPrint(
          "PrinterConnectionService: reconnexion impossible, nettoyage...");
      _cleanupDevice();
    } finally {
      _isReconnecting = false;
    }
  }

  /// Supprime le BlueDevice global et met à jour l'état.
  void _cleanupDevice() {
    if (Get.isRegistered<BlueDevice>()) {
      Get.delete<BlueDevice>(force: true);
    }
    isPrinterConnected.value = false;
  }

  /// Appelée après une connexion réussie depuis un contrôleur.
  void onPrinterConnected() {
    isPrinterConnected.value = true;
    // Redémarrer le monitoring pour repartir avec un timer frais
    _startMonitoring();
  }

  /// Appelée après une déconnexion volontaire depuis un contrôleur.
  void onPrinterDisconnected() {
    isPrinterConnected.value = false;
  }

  /// Tente une reconnexion à la demande (utilisé par le mixin avant impression).
  /// Retourne `true` si la connexion est active après la tentative.
  Future<bool> tryReconnect() async {
    // Déjà connecté ?
    try {
      final isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected) {
        isPrinterConnected.value = true;
        return true;
      }
    } catch (_) {}

    // Tentative de reconnexion
    final device = _currentDevice;
    if (device == null || device.isEmpty) return false;

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final reconnected = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.address,
      );
      if (reconnected) {
        isPrinterConnected.value = true;
        _startMonitoring();
        return true;
      }
    } catch (e) {
      debugPrint("PrinterConnectionService: tryReconnect error: $e");
    }

    return false;
  }

  /// Accès au BlueDevice actuellement enregistré dans GetX.
  BlueDevice? get _currentDevice {
    if (Get.isRegistered<BlueDevice>()) {
      return Get.find<BlueDevice>();
    }
    return null;
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    super.onClose();
  }
}
