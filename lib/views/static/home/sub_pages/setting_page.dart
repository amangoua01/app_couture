import 'dart:io';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/setting_tile.dart';
import 'package:ateliya/views/controllers/home/setting_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/abonnements_list_page.dart';
import 'package:ateliya/views/static/auth/profil_page.dart';
import 'package:ateliya/views/static/boutiques/boutiques_list_page.dart';
import 'package:ateliya/views/static/caisse/mouvement_caisse_list_page.dart';
import 'package:ateliya/views/static/clients/client_liste_page.dart';
import 'package:ateliya/views/static/depense/depense_list_page.dart';
import 'package:ateliya/views/static/home/sub_pages/statistique_entreprise_page.dart';
import 'package:ateliya/views/static/info/contact_us_page.dart';
import 'package:ateliya/views/static/info/terms_conditions_page.dart';
import 'package:ateliya/views/static/modele/modele_list_page.dart';
import 'package:ateliya/views/static/modele_boutique/modele_list_boutique_page.dart';
import 'package:ateliya/views/static/personnels/personnels_list_page.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
import 'package:ateliya/views/static/ravitaillement/ravitaillement_list_page.dart';
import 'package:ateliya/views/static/stats/stock_statistiques_page.dart';
import 'package:ateliya/views/static/surcursales/succursales_list_page.dart';
import 'package:ateliya/views/static/type_mesure/type_mesure_list_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SettingPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAF9),
          appBar: MainAppBar(
            enterpriseTitle: ctl.getEntite().value.libelle.value,
            notifCount: ctl.nbUnreadNotifs,
            onSelectionChanged: () => ctl.update(),
            onNotifRefresh: () => ctl.loadUnreadCount(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête de profil unifié contenant la photo, le nom et le QR code
                _UnifiedProfileHeader(ctl: ctl),
                const Gap(16),

                _QuickProfileCard(
                  name: ctl.user.fullName,
                  onTap: () => Get.to(() => const ProfilPage())
                      ?.then((_) => ctl.update()),
                ),
                const Gap(24),

                // ── Section Gestion de compte ─────────────────
                const _SectionLabel("Gestion de compte"),
                const Gap(8),
                _SettingsGroup(tiles: [
                  SettingTile(
                    title: "Statistiques",
                    icon: Icons.bar_chart_outlined,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    visible: ctl.user.isAdmin,
                    onTap: () => Get.to(
                      () => const StatistiqueEntreprisePage(),
                    ),
                  ),
                  SettingTile(
                    title: "Mes boutiques",
                    icon: Icons.storefront_outlined,
                    iconBgColor: AppColors.green.withValues(alpha: 0.12),
                    color: AppColors.green,
                    visible: ctl.user.isAdmin,
                    onTap: () => Get.to(() => const BoutiquesListPage()),
                  ),
                  SettingTile(
                    title: "Mouvements caisse",
                    icon: Icons.account_balance_wallet_outlined,
                    iconBgColor: AppColors.green.withValues(alpha: 0.12),
                    color: AppColors.green,
                    visible: ctl.user.isAdmin,
                    onTap: () => Get.to(
                      () => const MouvementCaisseListPage(),
                    ),
                  ),
                  SettingTile(
                    title: "Mes succursales",
                    icon: Icons.business_outlined,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    visible: ctl.user.isAdmin,
                    onTap: () => Get.to(() => const SuccursalesListPage()),
                  ),
                  SettingTile(
                    title: "Mon personnel",
                    icon: Icons.people_outline,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    visible: ctl.user.isAdmin,
                    onTap: () => Get.to(() => const PersonnelListPage()),
                  ),
                  SettingTile(
                    title: "Abonnements",
                    icon: Icons.card_membership_outlined,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.15),
                    color: AppColors.secondary,
                    visible: ctl.user.isAdmin,
                    onTap: () => Get.to(() => const AbonnementsListPage()),
                  ),
                  SettingTile(
                    title: "Mes dépenses",
                    icon: Icons.monetization_on_outlined,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.15),
                    color: AppColors.secondary,
                    visible: ctl.user.isAdmin,
                    onTap: () => Get.to(() => const DepenseListPage()),
                  ),
                  SettingTile(
                    title: "Imprimantes",
                    icon: Icons.print_outlined,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    showDivider: false,
                    onTap: () => Get.to(() => const PrintListPage()),
                  ),
                ]),
                const Gap(24),

                // ── Section Atelier & Catalogue ───────────────
                const _SectionLabel("Atelier & Catalogue"),
                const Gap(8),
                _SettingsGroup(tiles: [
                  SettingTile(
                    title: "Mes clients",
                    icon: Icons.group_outlined,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    onTap: () => Get.to(() => const ClientListePage()),
                  ),
                  SettingTile(
                    title: "Mes modèles",
                    icon: Icons.style_outlined,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.15),
                    color: AppColors.secondary,
                    visible: ctl.user.isAdmin &&
                        ctl.getEntite().value.type ==
                            EntiteEntrepriseType.boutique,
                    onTap: () => Get.to(() => const ModeleListPage()),
                  ),
                  SettingTile(
                    title: "Modèles boutiques",
                    icon: Icons.shopping_bag_outlined,
                    iconBgColor: AppColors.green.withValues(alpha: 0.12),
                    color: AppColors.green,
                    visible: ctl.user.isAdmin &&
                        ctl.getEntite().value.type ==
                            EntiteEntrepriseType.boutique,
                    onTap: () => Get.to(
                      () => const ModeleListBoutiquePage(),
                    ),
                  ),
                  SettingTile(
                    title: "Type de mesure",
                    icon: Icons.straighten_outlined,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.15),
                    color: AppColors.secondary,
                    visible: ctl.user.isAdmin &&
                        ctl.getEntite().value.type ==
                            EntiteEntrepriseType.succursale,
                    onTap: () => Get.to(() => const TypeMesureListPage()),
                  ),
                  SettingTile(
                    title: "Suivi de stock",
                    icon: Icons.analytics_outlined,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.15),
                    color: AppColors.secondary,
                    visible: ctl.user.isAdmin &&
                        ctl.getEntite().value.type ==
                            EntiteEntrepriseType.boutique,
                    onTap: () => Get.to(() => const StockStatistiquesPage()),
                  ),
                  SettingTile(
                    title: "Ravitaillements",
                    icon: Icons.inventory_2_outlined,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    visible: ctl.getEntite().value.type ==
                        EntiteEntrepriseType.boutique,
                    showDivider: false,
                    onTap: () => Get.to(
                      () => const RavitaillementListPage(),
                    ),
                  ),
                ]),
                const Gap(24),

                // ── Section À propos ──────────────────────────
                const _SectionLabel("À propos"),
                const Gap(8),
                _SettingsGroup(tiles: [
                  SettingTile(
                    title: "Contactez-nous",
                    icon: Icons.support_agent_outlined,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    onTap: () => Get.to(() => const ContactUsPage()),
                  ),
                  SettingTile(
                    title: "Termes & Conditions",
                    icon: Icons.gavel_outlined,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    showDivider: false,
                    onTap: () => Get.to(() => const TermsConditionsPage()),
                  ),
                ]),
                const Gap(24),

                // ── Section Partager l'application ───────────
                const _SectionLabel("Partager l'application"),
                const Gap(8),
                _SettingsGroup(tiles: [
                  SettingTile(
                    title: "Disponible sur Play Store",
                    icon: Icons.android_rounded,
                    iconBgColor:
                        const Color(0xFF34A853).withValues(alpha: 0.12),
                    color: const Color(0xFF34A853),
                    onTap: ctl.openPlayStore,
                  ),
                  SettingTile(
                    title: "Disponible sur App Store",
                    icon: Icons.apple_rounded,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.08),
                    color: AppColors.primary,
                    onTap: ctl.openAppStore,
                  ),
                  SettingTile(
                    title: "Copier le lien de partage",
                    icon: Icons.share_outlined,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.15),
                    color: AppColors.secondary,
                    showDivider: false,
                    onTap: ctl.shareApp,
                  ),
                ]),
                const Gap(24),

                // ── Déconnexion ───────────────────────────────
                _SettingsGroup(tiles: [
                  SettingTile(
                    title: "Déconnexion",
                    icon: Icons.logout_rounded,
                    iconBgColor:
                        const Color(0xFFC76D6D).withValues(alpha: 0.12),
                    color: const Color(0xFFC76D6D),
                    showDivider: false,
                    onTap: ctl.logoutUser,
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Widgets locaux ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.primary.withValues(alpha: 0.45),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> tiles;
  const _SettingsGroup({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(children: tiles),
      ),
    );
  }
}

class _QuickProfileCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const _QuickProfileCard({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.manage_accounts_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informations du profil",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppColors.primary,
                            letterSpacing: -0.1),
                      ),
                      const Gap(1),
                      Text(
                        "Modifier vos coordonnées personnelles",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnifiedProfileHeader extends StatelessWidget {
  final SettingPageVctl ctl;
  const _UnifiedProfileHeader({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final photo = ctl.user.photoProfil;
    final userName = ctl.user.fullName.isNotEmpty
        ? ctl.user.fullName
        : ctl.user.nom.value.isNotEmpty
            ? ctl.user.nom.value
            : "Utilisateur";

    final code = ctl.user.isAdmin
        ? (ctl.user.entreprise?.codeMarchand ?? "")
        : (ctl.user.myReferralCode ?? "");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Partie Gauche : Photo, Nom, Code Marchand
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Photo de profil
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.8),
                          width: 2,
                        ),
                      ),
                      child: photo != null && photo.isNotEmpty
                          ? CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(photo),
                            )
                          : const CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  AssetImage("assets/images/user.png"),
                            ),
                    ),
                    const Gap(12),
                    // Nom
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(2),
                          Text(
                            ctl.user.isAdmin
                                ? "Administrateur"
                                : "Collaborateur",
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (code.isNotEmpty) ...[
                  const Gap(14),
                  // Code Marchand / Parrainage
                  Text(
                    ctl.user.isAdmin ? "CODE MARCHAND" : "CODE PARRAINAGE",
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          code,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Gap(6),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: code));
                          Get.snackbar(
                            "Code copié !",
                            "Le code a été copié dans le presse-papiers.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF112C26),
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(15),
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.copy_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (code.isNotEmpty) ...[
            const Gap(12),
            // Partie Droite : QR Code directement affiché (Cliquable pour agrandir)
            GestureDetector(
              onTap: () => _showZoomedQrCode(context, code, ctl),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'qr_code_hero',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$code&color=0a3a30",
                      width: 85,
                      height: 85,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.qr_code_2_rounded,
                        size: 85,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showZoomedQrCode(
      BuildContext context, String code, SettingPageVctl ctl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ctl.user.isAdmin
                        ? "Mon Code Marchand"
                        : "Mon Code Parrainage",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.grey, size: 20),
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Hero(
                tag: 'qr_code_hero',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=$code&color=0a3a30",
                      width: 200,
                      height: 200,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.qr_code_2_rounded,
                        size: 200,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: code));
                      Get.snackbar(
                        "Code copié !",
                        "Le code a été copié dans le presse-papiers.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF112C26),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(15),
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: const Icon(
                        Icons.copy_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Text(
                ctl.user.isAdmin
                    ? "Partagez ce QR Code pour inviter des collaborateurs à rejoindre votre atelier."
                    : "Partagez ce QR Code pour parrainer un nouvel atelier.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
