import 'package:app_couture/tools/widgets/abonnement_tile.dart';
import 'package:app_couture/views/static/abonnements/forfait_list_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AbonnementsListPage extends StatelessWidget {
  const AbonnementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abonnements"),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const ForfaitListPage()),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        separatorBuilder: (context, index) => const Gap(10),
        itemCount: 10,
        itemBuilder: (context, index) => const AbonnementTile(),
      ),
    );
  }
}
