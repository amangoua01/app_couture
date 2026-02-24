import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/printer_list_tile.dart';
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
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text("Imprimantes"),
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: "Scanner",
                icon: ctl.isScanning
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(Icons.refresh_rounded),
                onPressed: ctl.checkPermissionsAndScan,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Get.to(() => const AddPrinterFromAdressePage()),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text("Ajouter",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: Column(
            children: [
              // ── Bandeau permission manquante ───────────────────────
              if (!ctl.permissionGranted)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.warning_amber_rounded,
                            color: Colors.orange.shade700, size: 18),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          "Permissions Bluetooth requises pour scanner.",
                          style: TextStyle(
                              color: Colors.orange.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: openAppSettings,
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.orange.shade800),
                        child: const Text("Ouvrir",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    // ── Section : Déjà utilisées ───────────────────
                    if (ctl.oldDevices.isNotEmpty) ...[
                      const _SectionHeader(
                        icon: Icons.history_rounded,
                        label: "Déjà utilisées",
                        color: AppColors.primary,
                      ),
                      const Gap(10),
                      ...ctl.oldDevices.map((item) {
                        final isConnected =
                            ctl.selectedPrinter.address == item.address;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: PrinterListTile(
                            item,
                            isConnected: isConnected,
                            onConnect: () => ctl.connectToPrinter(item),
                            onDelete: () => ctl.removeOldDevice(item),
                          ),
                        );
                      }),
                      const Gap(16),
                    ],

                    // ── Section : Appareils disponibles ───────────
                    _SectionHeader(
                      icon: Icons.bluetooth_searching_rounded,
                      label: "Appareils disponibles",
                      color: Colors.blue,
                      trailing: ctl.isScanning
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.blue))
                          : null,
                    ),
                    const Gap(10),

                    if (ctl.isScanning)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (ctl.scannedDevices.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: const EmptyDataWidget(
                          message:
                              "Aucune imprimante trouvée.\nAssurez-vous qu'elle est appairée dans les paramètres Bluetooth.",
                        ),
                      )
                    else
                      ...ctl.scannedDevices.map((item) {
                        final isConnected =
                            ctl.selectedPrinter.address == item.address;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: PrinterListTile(
                            item,
                            isConnected: isConnected,
                            onConnect: () => ctl.connectToPrinter(item),
                          ),
                        );
                      }),

                    const Gap(16),

                    // ── Note de bas de page ────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 16, color: Colors.blue[400]),
                          const Gap(10),
                          Expanded(
                            child: Text(
                              "Si votre imprimante n'apparaît pas, assurez-vous de l'avoir couplée dans les paramètres Bluetooth de votre téléphone.",
                              style: TextStyle(
                                  color: Colors.blue[700], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Widget? trailing;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const Gap(10),
        Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey[700]),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
