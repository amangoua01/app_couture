import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/forfait_config_section.dart';
import 'package:ateliya/views/static/abonnements/abonnement_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DowngradeSelectionOptionPage extends StatelessWidget {
  const DowngradeSelectionOptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuration du forfait")),
      body: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 50),
        children: [
          const ForfaitConfigSection(title: "Sélectionner les utilisateurs"),
          const ForfaitConfigSection(title: "Sélectionner les surcussales"),
          const ForfaitConfigSection(title: "Sélectionner les boutiques"),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CButton(
              title: "Suivant",
              onPressed: () => Get.to(() => const AbonnementPaymentPage()),
            ),
          ),
        ],
      ),
    );
  }
}
