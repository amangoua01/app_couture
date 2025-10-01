import 'package:app_couture/tools/widgets/setting_tile.dart';
import 'package:app_couture/views/static/abonnements/abonnements_list_page.dart';
import 'package:app_couture/views/static/categorie/categorie_list_page.dart';
import 'package:app_couture/views/static/clients/client_liste_page.dart';
import 'package:app_couture/views/static/type_mesure/type_mesure_list_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/user.png",
                  width: 100,
                  color: Colors.black,
                ),
                const Gap(10),
                const Text("PATRICK CYRILL"),
              ],
            ),
          ),
          const Text("Actions principales"),
          const SettingTile(title: "Mes informations"),
          const SettingTile(title: "Mes boutiques"),
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
            title: "Abonnements",
            onTap: () => Get.to(() => const AbonnementsListPage()),
          ),
          const SettingTile(title: "Déconnexion"),
        ],
      ),
    );
  }
}
