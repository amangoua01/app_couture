import 'package:ateliya/tools/widgets/abonnement_tile.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/abonnements/abonnements_list_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/forfait_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AbonnementsListPage extends StatelessWidget {
  const AbonnementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AbonnementsListPageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Abonnements"),
            foregroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.to(() => const ForfaitListPage()),
            child: const Icon(Icons.add),
          ),
          body: WrapperListview(
            isLoading: ctl.isLoading,
            padding: const EdgeInsets.all(15),
            items: ctl.abonnements,
            onRefresh: ctl.fetchAbonnements,
            itemBuilder: (e, i) => AbonnementTile(e),
          ),
        );
      },
    );
  }
}
