import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Paramètres"),
      ),
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
          const SettingTile(title: "Mes informations"),
          const SettingTile(title: "Déconnexion"),
        ],
      ),
    );
  }
}
