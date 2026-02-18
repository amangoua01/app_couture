import 'dart:convert';

import 'package:ateliya/tools/components/cache.dart';
import 'package:ateliya/tools/constants/cache_key.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/blue_device.dart';
import 'package:ateliya/tools/services/sound_service.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class AddPrinterFromAdressePageVctl extends GetxController {
  final adresseCtl = TextEditingController();

  Future<void> connect() async {
    if (adresseCtl.text.isEmpty) {
      CMessageDialog.show(message: "Veuillez renseigner une adresse MAC.");
      return;
    }

    final address = adresseCtl.text.trim();

    final rep = await CChoiceMessageDialog.show(
      message: "Voulez-vous vraiment vous connecter à $address ?",
    );

    if (rep == true) {
      // Tentative de connexion
      final bool res =
          await PrintBluetoothThermal.connect(macPrinterAddress: address)
              .load();

      if (res) {
        await SoundService.playBeep();

        // Création du device
        final printer = BlueDevice(
          name: "Imprimante Manuelle",
          address: address,
          isConnected: true,
        );

        // Sauvegarde dans l'historique
        await _saveToHistory(printer);

        CMessageDialog.show(
          message: "Connexion réussie !",
          isSuccess: true,
        );
        Get.back();
      } else {
        await SoundService.playError();
        CMessageDialog.show(
          message:
              "Impossible de se connecter à l'adresse $address.\nVérifiez qu'elle est correcte et que l'imprimante est allumée.",
        );
      }
    }
  }

  Future<void> _saveToHistory(BlueDevice newDevice) async {
    // Charger l'historique existant
    List<BlueDevice> oldDevices = [];
    final res = await Cache.getString(CacheKey.oldPrinters.name);

    if (res.isJson) {
      try {
        final List<dynamic> data = jsonDecode(res.value);
        oldDevices = data.map((e) => BlueDevice.fromJson(e)).toList();
      } catch (e) {
        // ignore
      }
    }

    // Ajouter si n'existe pas déjà
    if (!oldDevices.any((d) => d.address == newDevice.address)) {
      oldDevices.add(newDevice);

      await Cache.setString(
        CacheKey.oldPrinters.name,
        jsonEncode(oldDevices.map((e) => e.toJson()).toList()),
      );
    }
  }
}
