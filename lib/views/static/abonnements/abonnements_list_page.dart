import 'package:app_couture/views/static/abonnements/forfait_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AbonnementsListPage extends StatelessWidget {
  const AbonnementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Abonnements")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const ForfaitListPage()),
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text("Liste des abonnements"),
      ),
    );
  }
}
