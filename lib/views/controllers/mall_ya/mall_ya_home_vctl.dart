import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/static/mall_ya/mall_commandes_recues_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_dashboard_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_settings_page.dart';
import 'package:ateliya/views/static/mall_ya/mes_adresses_page.dart';
import 'package:ateliya/views/static/mall_ya/mes_favoris_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MallYaMenuItem {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final Color accentColor;
  final VoidCallback onTap;

  const MallYaMenuItem({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.accentColor,
    required this.onTap,
  });
}

class MallYaHomeVctl extends AuthViewController {
  late final List<MallYaMenuItem> menuItems;

  @override
  void onInit() {
    super.onInit();
    menuItems = [
      MallYaMenuItem(
        icon: Icons.space_dashboard_rounded,
        label: "Tableau de bord",
        gradient: const [Color(0xFF0A7A5A), Color(0xFF12B07E)],
        accentColor: const Color(0xFF0A7A5A),
        onTap: () => Get.to(() => const MallDashboardPage()),
      ),
      MallYaMenuItem(
        icon: Icons.shopping_bag_rounded,
        label: "Mes commandes",
        gradient: const [Color(0xFFB8860B), Color(0xFFDAA520)],
        accentColor: const Color(0xFFB8860B),
        onTap: () {},
      ),
      MallYaMenuItem(
        icon: Icons.favorite_rounded,
        label: "Mes favoris",
        gradient: const [Color(0xFFC2185B), Color(0xFFEC407A)],
        accentColor: const Color(0xFFC2185B),
        onTap: () => Get.to(() => const MesFavorisPage()),
      ),
      MallYaMenuItem(
        icon: Icons.place_rounded,
        label: "Mes adresses",
        gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
        accentColor: const Color(0xFF1565C0),
        onTap: () => Get.to(() => const MesAdressesPage()),
      ),
      MallYaMenuItem(
        icon: Icons.move_to_inbox_rounded,
        label: "Commandes reçues",
        gradient: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        accentColor: const Color(0xFF2E7D32),
        onTap: () => Get.to(() => const MallCommandesRecuesPage()),
      ),
      MallYaMenuItem(
        icon: Icons.tune_rounded,
        label: "Paramètres boutique",
        gradient: const [Color(0xFF37474F), Color(0xFF78909C)],
        accentColor: const Color(0xFF37474F),
        onTap: () => Get.to(() => const MallSettingsPage()),
      ),
      MallYaMenuItem(
        icon: Icons.panorama_rounded,
        label: "Couvertures",
        gradient: const [Color(0xFFE65100), Color(0xFFFFA726)],
        accentColor: const Color(0xFFE65100),
        onTap: () {},
      ),
      MallYaMenuItem(
        icon: Icons.auto_awesome_rounded,
        label: "Modèles boutique",
        gradient: const [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
        accentColor: const Color(0xFF6A1B9A),
        onTap: () {},
      ),
    ];
  }
}
