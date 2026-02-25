import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/notif_badge_icon.dart';
import 'package:ateliya/tools/widgets/setting_tile.dart';
import 'package:ateliya/views/controllers/home/setting_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/abonnements_list_page.dart';
import 'package:ateliya/views/static/auth/profil_page.dart';
import 'package:ateliya/views/static/boutiques/boutiques_list_page.dart';
import 'package:ateliya/views/static/clients/client_liste_page.dart';
import 'package:ateliya/views/static/depense/depense_list_page.dart';
import 'package:ateliya/views/static/info/contact_us_page.dart';
import 'package:ateliya/views/static/info/terms_conditions_page.dart';
import 'package:ateliya/views/static/modele/modele_list_page.dart';
import 'package:ateliya/views/static/modele_boutique/modele_list_boutique_page.dart';
import 'package:ateliya/views/static/personnels/personnels_list_page.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
import 'package:ateliya/views/static/ravitaillement/ravitaillement_list_page.dart';
import 'package:ateliya/views/static/surcursales/succursales_list_page.dart';
import 'package:ateliya/views/static/type_mesure/type_mesure_list_page.dart';
import 'package:flutter/material.dart';
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
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            slivers: [
              // ── SliverAppBar avec profil ──────────────────────────
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                elevation: 0,
                centerTitle: true,
                title: const Text("Paramètres"),
                actions: [
                  NotifBadgeIcon(
                    count: ctl.nbUnreadNotifs,
                    onRefresh: () => ctl.loadUnreadCount(),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          Color.fromRGBO(56, 152, 160, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Gap(40),
                          // Avatar
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 36,
                              backgroundImage:
                                  const AssetImage("assets/images/user.png"),
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            ctl.user.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const Gap(3),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Compte Ateliya",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Corps ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Bouton Mon profil (accès rapide)
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
                        title: "Mes boutiques",
                        icon: Icons.storefront_outlined,
                        iconBgColor: const Color(0xFFE8F5E9),
                        color: Colors.green[700],
                        visible: ctl.user.isAdmin,
                        onTap: () => Get.to(() => const BoutiquesListPage()),
                      ),
                      SettingTile(
                        title: "Mes succursales",
                        icon: Icons.business_outlined,
                        iconBgColor: const Color(0xFFE3F2FD),
                        color: Colors.blue[700],
                        visible: ctl.user.isAdmin,
                        onTap: () => Get.to(() => const SuccursalesListPage()),
                      ),
                      SettingTile(
                        title: "Mon personnel",
                        icon: Icons.people_outline,
                        iconBgColor: const Color(0xFFF3E5F5),
                        color: Colors.purple[700],
                        visible: ctl.user.isAdmin,
                        onTap: () => Get.to(() => const PersonnelListPage()),
                      ),
                      SettingTile(
                        title: "Abonnements",
                        icon: Icons.card_membership_outlined,
                        iconBgColor: const Color(0xFFFFF8E1),
                        color: Colors.amber[800],
                        visible: ctl.user.isAdmin,
                        onTap: () => Get.to(() => const AbonnementsListPage()),
                      ),
                      SettingTile(
                        title: "Mes dépenses",
                        icon: Icons.monetization_on_outlined,
                        iconBgColor: const Color(0xFFFFEBEE),
                        color: Colors.red[600],
                        visible: ctl.user.isAdmin,
                        onTap: () => Get.to(() => const DepenseListPage()),
                      ),
                      SettingTile(
                        title: "Imprimantes",
                        icon: Icons.print_outlined,
                        iconBgColor: AppColors.primary.withValues(alpha: 0.1),
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
                        iconBgColor: const Color(0xFFE3F2FD),
                        color: Colors.blue[600],
                        onTap: () => Get.to(() => const ClientListePage()),
                      ),
                      SettingTile(
                        title: "Mes modèles",
                        icon: Icons.style_outlined,
                        iconBgColor: const Color(0xFFF3E5F5),
                        color: Colors.purple[600],
                        visible: ctl.user.isAdmin,
                        onTap: () => Get.to(() => const ModeleListPage()),
                      ),
                      SettingTile(
                        title: "Modèles boutiques",
                        icon: Icons.shopping_bag_outlined,
                        iconBgColor: const Color(0xFFE8F5E9),
                        color: Colors.green[600],
                        visible: ctl.user.isAdmin,
                        onTap: () =>
                            Get.to(() => const ModeleListBoutiquePage()),
                      ),
                      SettingTile(
                        title: "Type de mesure",
                        icon: Icons.straighten_outlined,
                        iconBgColor: const Color(0xFFFFF3E0),
                        color: Colors.orange[700],
                        visible: ctl.user.isAdmin,
                        onTap: () => Get.to(() => const TypeMesureListPage()),
                      ),
                      SettingTile(
                        title: "Ravitaillements",
                        icon: Icons.inventory_2_outlined,
                        iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                        visible: ctl.getEntite().value is Boutique,
                        showDivider: false,
                        onTap: () =>
                            Get.to(() => const RavitaillementListPage()),
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
                        iconBgColor: const Color(0xFFE3F2FD),
                        color: Colors.blue[600],
                        onTap: () => Get.to(() => const ContactUsPage()),
                      ),
                      SettingTile(
                        title: "Termes & Conditions",
                        icon: Icons.gavel_outlined,
                        iconBgColor: const Color(0xFFF3E5F5),
                        color: Colors.purple[600],
                        showDivider: false,
                        onTap: () => Get.to(() => const TermsConditionsPage()),
                      ),
                    ]),
                    const Gap(24),

                    // ── Déconnexion ───────────────────────────────
                    _SettingsGroup(tiles: [
                      SettingTile(
                        title: "Déconnexion",
                        icon: Icons.logout_rounded,
                        iconBgColor: Colors.red.withValues(alpha: 0.1),
                        color: Colors.red,
                        showDivider: false,
                        onTap: ctl.logoutUser,
                      ),
                    ]),
                  ]),
                ),
              ),
            ],
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
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey[500],
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
    // Filtrer les SizedBox.shrink() (tiles non visibles)
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_outline_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mon profil",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Gap(2),
                    Text(
                      name,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Modifier",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
