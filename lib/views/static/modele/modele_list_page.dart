import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/modele/modele_list_page_vctl.dart';
import 'package:ateliya/views/static/modele/edition_modele_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeleListPage extends StatelessWidget {
  const ModeleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ModeleListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Modèles",
          createPage: const EditionModelePage(),
          itemBuilder: (_, i, selected) => ListItem(ctl,
              leadingImage: (ctl.data.items[i].photo == null)
                  ? "assets/images/svg/modele.svg"
                  : (ctl.data.items[i].photo is FichierServer)
                      ? (ctl.data.items[i].photo as FichierServer).fullUrl!
                      : null,
              editionPage: EditionModelePage(item: ctl.data.items[i]),
              index: i,
              title: ctl.data.items[i].libelle.value),
        );
      },
    );
  }
}
