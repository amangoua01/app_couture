import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/depense/depense_list_page_vctl.dart';
import 'package:ateliya/views/static/depense/depense_detail_page.dart';
import 'package:ateliya/views/static/depense/edition_depense_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepenseListPage extends StatelessWidget {
  const DepenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DepenseListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Mes dépenses",
          createPage: const EditionDepensePage(),
          itemBuilder: (e, i, selected) => ListItem(
            ctl,
            leadingImage:
                "assets/images/user.png", // Placeholder or relevant icon
            editionPage: DepenseDetailPage(depense: ctl.data.items[i]),
            index: i,
            title:
                "${ctl.data.items[i].familleDepense?.libelle ?? 'Aucune famille'} - ${ctl.data.items[i].familleDepense?.groupeDepense?.libelle ?? ''}",
            subtitle:
                "${ctl.data.items[i].montant.toAmount(unit: "F")} • ${ctl.data.items[i].createdAt.toFrenchDateTime}",
            selected: selected,
          ),
        );
      },
    );
  }
}
