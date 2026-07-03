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
          backgroundColor: const Color(0xFFF8FAF9),
          appBar: AppBar(
            title: const Text("Imprimantes"),
            actions: [
              IconButton(
                tooltip: "Scanner",
                icon: ctl.isScanning
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: ctl.checkPermissionsAndScan,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.to(() => const AddPrinterFromAdressePage()),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_rounded),
          ),
          body: Column(
            children: [
              // ── Bandeau permission manquante (Modernisé aux couleurs de la marque) ───────────────────────
              if (!ctl.permissionGranted)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Autorisation requise",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              "Permissions Bluetooth requises pour scanner.",
                              style: TextStyle(
                                color: AppColors.primary.withValues(alpha: 0.6),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: openAppSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Ouvrir",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  children: [
                    // ── Section : Déjà utilisées ───────────────────
                    if (ctl.oldDevices.isNotEmpty) ...[
                      const _SectionHeader(
                        icon: Icons.history_rounded,
                        label: "Déjà utilisées",
                        color: AppColors.primary,
                      ),
                      const Gap(12),
                      ...ctl.oldDevices.map((item) {
                        final isConnected =
                            ctl.selectedPrinter.address == item.address;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PrinterListTile(
                            item,
                            isConnected: isConnected,
                            onConnect: () => ctl.connectToPrinter(item),
                            onDelete: () => ctl.removeOldDevice(item),
                          ),
                        );
                      }),
                      const Gap(20),
                    ],

                    // ── Section : Appareils disponibles ───────────
                    _SectionHeader(
                      icon: Icons.bluetooth_searching_rounded,
                      label: "Appareils disponibles",
                      color: AppColors.primary,
                      trailing: ctl.isScanning
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    const Gap(12),

                    if (ctl.isScanning)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                              const Gap(14),
                              Text(
                                "Recherche d'imprimantes en cours...",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppColors.primary.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PrinterListTile(
                            item,
                            isConnected: isConnected,
                            onConnect: () => ctl.connectToPrinter(item),
                          ),
                        );
                      }),

                    const Gap(24),

                    // ── Note de bas de page (Modernisé - Style Ateliya) ────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Astuce de connexion",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Gap(3),
                                Text(
                                  "Si votre imprimante n'apparaît pas, assurez-vous de l'avoir couplée dans les paramètres Bluetooth de votre téléphone.",
                                  style: TextStyle(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const Gap(12),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11.5,
            color: AppColors.primary.withValues(alpha: 0.8),
            letterSpacing: 0.6,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
