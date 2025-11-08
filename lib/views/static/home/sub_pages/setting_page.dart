import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/setting_tile.dart';
import 'package:app_couture/views/controllers/home/setting_page_vctl.dart';
import 'package:app_couture/views/static/abonnements/abonnements_list_page.dart';
import 'package:app_couture/views/static/auth/profil_page.dart';
import 'package:app_couture/views/static/boutiques/boutiques_list_page.dart';
import 'package:app_couture/views/static/categorie/categorie_list_page.dart';
import 'package:app_couture/views/static/clients/client_liste_page.dart';
import 'package:app_couture/views/static/modele/modele_list_page.dart';
import 'package:app_couture/views/static/personnels/personnels_list_page.dart';
import 'package:app_couture/views/static/surcursales/succursales_list_page.dart';
import 'package:app_couture/views/static/type_mesure/type_mesure_list_page.dart';
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
            appBar: AppBar(title: const Text("Paramètres")),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Badge(
                        padding: const EdgeInsets.all(5),
                        alignment: const Alignment(.4, .7),
                        label: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        backgroundColor: AppColors.primary,
                        child: Image.asset(
                          "assets/images/user.png",
                          width: 100,
                          color: Colors.black,
                        ),
                      ),
                      const Gap(10),
                      Text(ctl.user.fullName),
                    ],
                  ),
                ),
                const Text("Actions principales"),
                SettingTile(
                  title: "Mes informations",
                  onTap: () => Get.to(() => const ProfilPage()),
                ),
                SettingTile(
                  title: "Mes boutiques",
                  onTap: () => Get.to(() => const BoutiquesListPage()),
                ),
                SettingTile(
                  title: "Mon personnel",
                  onTap: () => Get.to(() => const PersonnelListPage()),
                ),
                SettingTile(
                  title: "Mes surcussales",
                  onTap: () => Get.to(() => const SuccursalesListPage()),
                ),
                SettingTile(
                  title: "Type de mesure",
                  onTap: () => Get.to(() => const TypeMesureListPage()),
                ),
                SettingTile(
                  title: "Catégories",
                  onTap: () => Get.to(() => const CategorieListPage()),
                ),
                SettingTile(
                  title: "Mes clients",
                  onTap: () => Get.to(() => const ClientListePage()),
                ),
                SettingTile(
                  title: "Mes modèles",
                  onTap: () => Get.to(() => const ModeleListPage()),
                ),
                SettingTile(
                  title: "Mes modèles boutiques",
                  onTap: () => Get.to(() => const ClientListePage()),
                ),
                SettingTile(
                  title: "Abonnements",
                  onTap: () => Get.to(() => const AbonnementsListPage()),
                ),
                SettingTile(
                  title: "Déconnexion",
                  onTap: ctl.logoutUser,
                ),
              ],
            ),
          );
        });
  }
}
