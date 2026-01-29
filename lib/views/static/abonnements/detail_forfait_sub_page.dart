import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/static/abonnements/operator_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailForfaitSubPage extends StatelessWidget {
  final ModuleAbonnement forfait;
  const DetailForfaitSubPage(this.forfait, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Text(
          forfait.code.value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: forfait.ligneModuleAvantages
              .map(
                (e) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    e.libelle.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    e.description.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    e.value.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
        ),
        CButton(
          title: "Je m'abonne",
          onPressed: () => Get.to(() => OperatorListPage(forfait)),
        ),
      ],
    );
  }
}
