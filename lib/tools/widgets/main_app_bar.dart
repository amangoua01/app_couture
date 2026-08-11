import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/services/printer_connection_service.dart';
import 'package:ateliya/tools/widgets/enterprise_selector_app_bar_title.dart';
import 'package:ateliya/tools/widgets/notif_badge_icon.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String enterpriseTitle;
  final VoidCallback onSelectionChanged;
  final int notifCount;
  final VoidCallback onNotifRefresh;
  const MainAppBar({
    super.key,
    required this.enterpriseTitle,
    required this.onSelectionChanged,
    required this.notifCount,
    required this.onNotifRefresh,
  });

  PrinterConnectionService? get _printerService =>
      Get.isRegistered<PrinterConnectionService>()
          ? Get.find<PrinterConnectionService>()
          : null;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(color: AppColors.secondary, width: 2),
          ),
          alignment: Alignment.center,
          child: _buildAvatar(),
        ),
      ),
      title: EnterpriseSelectorAppBarTitle(
        title: enterpriseTitle,
        onSelectionChanged: onSelectionChanged,
      ),
      actions: [
        _printerService == null
            ? _buildPrinterButton(isConnected: false)
            : Obx(() => _buildPrinterButton(
                isConnected: _printerService!.isPrinterConnected.value)),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: NotifBadgeIcon(
            count: notifCount,
            onRefresh: onNotifRefresh,
            color: Colors.white,
            size: 26,
            isPremiumStyle: false,
          ),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  User? get _user => Get.isRegistered<User>() ? Get.find<User>() : null;

  Widget _buildPrinterButton({required bool isConnected}) {
    return IconButton(
      onPressed: () => Get.to(() => const PrintListPage()),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.print_rounded,
            color: Colors.white,
            size: 26,
          ),
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: isConnected ? Colors.greenAccent : Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
      tooltip: isConnected ? "Imprimante connectée" : "Imprimante déconnectée",
    );
  }

  Widget _buildAvatar() {
    final photo = _user?.photoProfil;
    if (photo != null) {
      return ClipOval(
        child: Image.network(
          photo,
          width: 35,
          height: 35,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildInitial(),
        ),
      );
    }
    return _buildInitial();
  }

  Widget _buildInitial() {
    final user = _user;
    final name = (user?.prenoms?.isNotEmpty == true
            ? user!.prenoms!
            : user?.nom?.isNotEmpty == true
                ? user!.nom!
                : "U")
        .trim();
    return Text(
      name.substring(0, 1).toUpperCase(),
      style: const TextStyle(
        color: AppColors.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
