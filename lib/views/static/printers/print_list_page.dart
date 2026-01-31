import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/printer_list_tile.dart';
import 'package:ateliya/tools/widgets/text_divider.dart';
import 'package:ateliya/views/controllers/print/print_list_page_vctl.dart';
import 'package:ateliya/views/static/printers/add_printer_from_adresse_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintListPage extends StatelessWidget {
  const PrintListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrintListPageVctl>(
      init: PrintListPageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Imprimantes"),
            actions: [
              IconButton(
                icon: ctl.isScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.black, strokeWidth: 2))
                    : const Icon(Icons.refresh),
                onPressed: ctl.checkPermissionsAndScan,
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.to(() => const AddPrinterFromAdressePage()),
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              // permission warning
              if (!ctl.permissionGranted)
                Container(
                  color: Colors.orange.shade100,
                  padding: const EdgeInsets.all(12),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.deepOrange),
                      Gap(10),
                      Expanded(
                        child: Text(
                            "Permissions Bluetooth requises pour scanner."),
                      ),
                      TextButton(
                        onPressed: openAppSettings,
                        child: Text("Ouvrir"),
                      )
                    ],
                  ),
                ),

              // Historique
              if (ctl.oldDevices.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextDivider("Déjà utilisées"),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ctl.oldDevices.length,
                  separatorBuilder: (_, __) => const Gap(8),
                  itemBuilder: (ctx, index) {
                    final item = ctl.oldDevices[index];
                    // Check real connection status
                    final isConnected =
                        ctl.selectedPrinter.address == item.address;
                    return PrinterListTile(
                      item,
                      isConnected: isConnected,
                      onConnect: () => ctl.connectToPrinter(item),
                      onDelete: () => ctl.removeOldDevice(item),
                    );
                  },
                )
              ],

              // Disponibles
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: TextDivider("Appareils disponibles"),
              ),

              Expanded(
                child: ctl.isScanning
                    ? const Center(child: CircularProgressIndicator())
                    : (ctl.scannedDevices.isEmpty
                        ? const Center(
                            child: EmptyDataWidget(
                                message:
                                    "Aucune imprimante trouvée.\nVérifiez qu'elle est appairée dans les paramètres."))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            itemCount: ctl.scannedDevices.length,
                            separatorBuilder: (_, __) => const Gap(8),
                            itemBuilder: (ctx, index) {
                              final item = ctl.scannedDevices[index];
                              final isConnected =
                                  ctl.selectedPrinter.address == item.address;
                              return PrinterListTile(
                                item,
                                isConnected: isConnected,
                                onConnect: () => ctl.connectToPrinter(item),
                                // Pas de delete sur la liste scan
                              );
                            },
                          )),
              ),

              // Hint footer
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Note : Si votre imprimante n'apparaît pas, assurez-vous de l'avoir couplée dans les paramètres Bluetooth de votre téléphone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
