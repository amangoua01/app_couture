import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/tools/services/mall_service.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/static/mall_ya/mall_commandes_recues_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_couvertures_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_dashboard_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_modeles_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_settings_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_status_page.dart';
import 'package:ateliya/views/static/mall_ya/mes_adresses_page.dart';
import 'package:ateliya/views/static/mall_ya/mes_commandes_page.dart';
import 'package:ateliya/views/static/mall_ya/mes_favoris_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MallYaMenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final Color accentColor;
  final VoidCallback onTap;

  const MallYaMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.accentColor,
    required this.onTap,
  });
}

class MallYaHomeVctl extends AuthViewController {
  late final List<MallYaMenuItem> menuItems;

  int currentIndex = 0;

  String? get code => user.entreprise?.codeMarchand;

  Future<void> shareBoutique() async {
    final c = code;
    if (c == null || c.isEmpty) return;
    try {
      await MallService.share(c);
    } catch (_) {
      Get.snackbar(
        'Partage indisponible',
        "Le partage n'est pas supporté sur cet appareil.",
      );
    }
  }

  Future<void> copierLien() async {
    final c = code;
    if (c == null || c.isEmpty) return;
    await MallService.copyLink(c);
    Get.snackbar('Lien copié', MallService.urlOf(c).toString());
  }

  @override
  void onInit() {
    super.onInit();
    menuItems = [
      MallYaMenuItem(
        icon: AppIcons.chartLineUp,
        label: "Tableau de bord",
        subtitle: "Statistiques & aperçu",
        color: const Color(0xFF0A7A5A),
        accentColor: const Color(0xFF0A7A5A),
        onTap: () => Get.to(() => const MallDashboardPage()),
      ),
      MallYaMenuItem(
        icon: AppIcons.tShirt,
        label: "Modèles boutique",
        subtitle: "Gérez vos modèles Mall",
        color: const Color(0xFF6A1B9A),
        accentColor: const Color(0xFF6A1B9A),
        onTap: () => Get.to(() => const MallModelesPage()),
      ),
      MallYaMenuItem(
        icon: AppIcons.tray,
        label: "Commandes reçues",
        subtitle: "Suivez vos commandes",
        color: const Color(0xFF2E7D32),
        accentColor: const Color(0xFF2E7D32),
        onTap: () => Get.to(() => const MallCommandesRecuesPage()),
      ),
      MallYaMenuItem(
        icon: AppIcons.shoppingBag,
        label: "Mes commandes",
        subtitle: "Historique d'achats",
        color: const Color(0xFFB8860B),
        accentColor: const Color(0xFFB8860B),
        onTap: () => Get.to(() => const MesCommandesPage()),
      ),
      MallYaMenuItem(
        icon: AppIcons.heart,
        label: "Mes favoris",
        subtitle: "Modèles sauvegardés",
        color: const Color(0xFFC2185B),
        accentColor: const Color(0xFFC2185B),
        onTap: () => Get.to(() => const MesFavorisPage()),
      ),
      MallYaMenuItem(
        icon: AppIcons.mapPin,
        label: "Mes adresses",
        subtitle: "Adresses de livraison",
        color: const Color(0xFF1565C0),
        accentColor: const Color(0xFF1565C0),
        onTap: () => Get.to(() => const MesAdressesPage()),
      ),
      MallYaMenuItem(
        icon: AppIcons.image,
        label: "Couvertures",
        subtitle: "Images de votre boutique",
        color: const Color(0xFFE65100),
        accentColor: const Color(0xFFE65100),
        onTap: () => Get.to(() => const MallCouverturesPage()),
      ),
      MallYaMenuItem(
        icon: AppIcons.storefront,
        label: "Statut boutique",
        subtitle: "Ouverte / Fermée",
        color: const Color(0xFF00695C),
        accentColor: const Color(0xFF00695C),
        onTap: () => Get.to(() => const MallStatusPage()),
      ),
      MallYaMenuItem(
        icon: AppIcons.sliders,
        label: "Paramètres boutique",
        subtitle: "Configuration générale",
        color: const Color(0xFF37474F),
        accentColor: const Color(0xFF37474F),
        onTap: () => Get.to(() => const MallSettingsPage()),
      ),
    ];
  }
}
