import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:ateliya/views/static/mall_ya/mall_commandes_recues_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_couvertures_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_dashboard_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_modeles_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_settings_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_status_page.dart';
import 'package:ateliya/views/static/mall_ya/mes_commandes_page.dart';
import 'package:ateliya/views/static/mall_ya/mes_adresses_page.dart';
import 'package:ateliya/views/static/mall_ya/mes_favoris_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MallYaMenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final List<Color> gradient;
  final Color accentColor;
  final VoidCallback onTap;

  const MallYaMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.accentColor,
    required this.onTap,
  });
}

class MallYaHomeVctl extends AuthViewController {
  late final List<MallYaMenuItem> menuItems;

  Future<void> shareBoutique() async {
    final code = user.entreprise?.codeMarchand ?? '';
    final url = 'https://malliya.ateliya.com/enterprise/$code';
    print('🔗 Share URL: $url');
    print('🏪 Code marchand: $code');
    try {
      await Share.share('Découvrez notre boutique sur Mall Ya :\n$url');
    } catch (e, stack) {
      print('❌ Share error: $e');
      print('📋 Stack: $stack');
      Get.snackbar('Partage indisponible',
          'Le partage n\'est pas supporté sur cet appareil.');
    }
  }

  @override
  void onInit() {
    super.onInit();
    menuItems = [
      MallYaMenuItem(
        icon: Icons.space_dashboard_rounded,
        label: "Tableau de bord",
        subtitle: "Statistiques & aperçu",
        gradient: const [Color(0xFF0A7A5A), Color(0xFF12B07E)],
        accentColor: const Color(0xFF0A7A5A),
        onTap: () => Get.to(() => const MallDashboardPage()),
      ),
      MallYaMenuItem(
        icon: Icons.auto_awesome_rounded,
        label: "Modèles boutique",
        subtitle: "Gérez vos modèles Mall",
        gradient: const [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
        accentColor: const Color(0xFF6A1B9A),
        onTap: () => Get.to(() => const MallModelesPage()),
      ),
      MallYaMenuItem(
        icon: Icons.move_to_inbox_rounded,
        label: "Commandes reçues",
        subtitle: "Suivez vos commandes",
        gradient: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        accentColor: const Color(0xFF2E7D32),
        onTap: () => Get.to(() => const MallCommandesRecuesPage()),
      ),
      MallYaMenuItem(
        icon: Icons.shopping_bag_rounded,
        label: "Mes commandes",
        subtitle: "Historique d'achats",
        gradient: const [Color(0xFFB8860B), Color(0xFFDAA520)],
        accentColor: const Color(0xFFB8860B),
        onTap: () => Get.to(() => const MesCommandesPage()),
      ),
      MallYaMenuItem(
        icon: Icons.favorite_rounded,
        label: "Mes favoris",
        subtitle: "Modèles sauvegardés",
        gradient: const [Color(0xFFC2185B), Color(0xFFEC407A)],
        accentColor: const Color(0xFFC2185B),
        onTap: () => Get.to(() => const MesFavorisPage()),
      ),
      MallYaMenuItem(
        icon: Icons.place_rounded,
        label: "Mes adresses",
        subtitle: "Adresses de livraison",
        gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
        accentColor: const Color(0xFF1565C0),
        onTap: () => Get.to(() => const MesAdressesPage()),
      ),
      MallYaMenuItem(
        icon: Icons.panorama_rounded,
        label: "Couvertures",
        subtitle: "Images de votre boutique",
        gradient: const [Color(0xFFE65100), Color(0xFFFFA726)],
        accentColor: const Color(0xFFE65100),
        onTap: () => Get.to(() => const MallCouverturesPage()),
      ),
      MallYaMenuItem(
        icon: Icons.toggle_on_rounded,
        label: "Statut boutique",
        subtitle: "Ouverte / Fermée",
        gradient: const [Color(0xFF00695C), Color(0xFF26A69A)],
        accentColor: const Color(0xFF00695C),
        onTap: () => Get.to(() => const MallStatusPage()),
      ),
      MallYaMenuItem(
        icon: Icons.tune_rounded,
        label: "Paramètres boutique",
        subtitle: "Configuration générale",
        gradient: const [Color(0xFF37474F), Color(0xFF78909C)],
        accentColor: const Color(0xFF37474F),
        onTap: () => Get.to(() => const MallSettingsPage()),
      ),
    ];
  }
}
