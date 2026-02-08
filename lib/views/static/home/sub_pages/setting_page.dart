import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/notif_badge_icon.dart';
import 'package:ateliya/tools/widgets/setting_tile.dart';
import 'package:ateliya/views/controllers/home/setting_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/abonnements_list_page.dart';
import 'package:ateliya/views/static/auth/profil_page.dart';
import 'package:ateliya/views/static/boutiques/boutiques_list_page.dart';
import 'package:ateliya/views/static/clients/client_liste_page.dart';
import 'package:ateliya/views/static/depense/depense_list_page.dart';
import 'package:ateliya/views/static/modele/modele_list_page.dart';
import 'package:ateliya/views/static/modele_boutique/modele_list_boutique_page.dart';
import 'package:ateliya/views/static/personnels/personnels_list_page.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
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
          backgroundColor: Colors.grey[50], // Light background
          appBar: AppBar(
            title: const Text(
              "Paramètres",
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0,
            centerTitle: true,
            actions: [
              NotifBadgeIcon(
                count: ctl.nbUnreadNotifs,
                onRefresh: () => ctl.loadUnreadCount(),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Profil Header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            const AssetImage("assets/images/user.png"),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    const Gap(10),
                    Text(
                      ctl.user.fullName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "Compte Ateliya",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Gap(30),

              // Section Gestion
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 8),
                child: Text("Gestion de compte",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    SettingTile(
                      title: "Mon profil",
                      icon: Icons.person_outline,
                      onTap: () => Get.to(() => const ProfilPage())?.then(
                        (e) => ctl.update(),
                      ),
                    ),
                    SettingTile(
                      visible: ctl.user.isAdmin,
                      title: "Mes boutiques",
                      icon: Icons.storefront_outlined,
                      onTap: () => Get.to(() => const BoutiquesListPage()),
                    ),
                    SettingTile(
                      visible: ctl.user.isAdmin,
                      title: "Mes succursales",
                      icon: Icons.business_outlined,
                      onTap: () => Get.to(() => const SuccursalesListPage()),
                    ),
                    SettingTile(
                      visible: ctl.user.isAdmin,
                      title: "Mon personnel",
                      icon: Icons.people_outline,
                      onTap: () => Get.to(() => const PersonnelListPage()),
                    ),
                    SettingTile(
                      visible: ctl.user.isAdmin,
                      title: "Abonnements",
                      icon: Icons.card_membership_outlined,
                      onTap: () => Get.to(() => const AbonnementsListPage()),
                    ),
                    SettingTile(
                      visible: ctl.user.isAdmin,
                      title: "Mes dépenses",
                      icon: Icons.monetization_on_outlined,
                      onTap: () => Get.to(() => const DepenseListPage()),
                    ),
                    SettingTile(
                      title: "Imprimantes",
                      icon: Icons.print_outlined,
                      onTap: () => Get.to(() => const PrintListPage()),
                    ),
                  ],
                ),
              ),
              const Gap(20),

              // Section Atelier
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 8),
                child: Text("Atelier & Catalogue",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.02), blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [
                    SettingTile(
                      title: "Mes clients",
                      icon: Icons.group_outlined,
                      onTap: () => Get.to(() => const ClientListePage()),
                    ),
                    SettingTile(
                      visible: ctl.user.isAdmin,
                      title: "Mes modèles",
                      icon: Icons.style_outlined,
                      onTap: () => Get.to(() => const ModeleListPage()),
                    ),
                    SettingTile(
                      title: "Mes modèles boutiques",
                      icon: Icons.shopping_bag_outlined,
                      onTap: () => Get.to(() => const ModeleListBoutiquePage()),
                    ),
                    SettingTile(
                      visible: ctl.user.isAdmin,
                      title: "Type de mesure",
                      icon: Icons.straighten_outlined,
                      onTap: () => Get.to(() => const TypeMesureListPage()),
                    ),
                  ],
                ),
              ),
              const Gap(30),

              // Déconnexion
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: SettingTile(
                  title: "Déconnexion",
                  icon: Icons.logout,
                  color: Colors.red,
                  onTap: ctl.logoutUser,
                ),
              ),
              const Gap(30),
            ],
          ),
        );
      },
    );
  }
}
