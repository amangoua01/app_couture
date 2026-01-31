import 'package:ateliya/tools/services/thermal_printer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterSelectionDialog extends StatefulWidget {
  const PrinterSelectionDialog({super.key});

  @override
  State<PrinterSelectionDialog> createState() => _PrinterSelectionDialogState();
}

class _PrinterSelectionDialogState extends State<PrinterSelectionDialog> {
  final _service = ThermalPrinterService();
  List<BluetoothInfo> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final granted = await _service.checkPermission();
    if (!granted) {
      // Prompt user or handle error
    }

    // Get paired devices
    final devices = await _service.getPairedDevices();
    if (mounted) {
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Sélectionner une imprimante"),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _devices.isEmpty
                ? const Text(
                    "Aucune imprimante associée trouvée. Veuillez appairer votre imprimante dans les paramètres Bluetooth.")
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _devices.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return ListTile(
                        leading: const Icon(Icons.print),
                        title: Text(device.name),
                        subtitle: Text(device.macAdress),
                        onTap: () async {
                          setState(() => _isLoading = true);
                          try {
                            final connected =
                                await _service.connect(device.macAdress);
                            if (connected) {
                              Get.back(result: true);
                            } else {
                              Get.snackbar("Erreur",
                                  "Impossible de se connecter à l'imprimante");
                            }
                          } catch (e) {
                            Get.snackbar("Erreur", "Erreur de connexion: $e");
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                      );
                    },
                  ),
      ),
      actions: [
        TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Annuler")),
      ],
    );
  }
}
