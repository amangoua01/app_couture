import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/modele_boutique/modele_boutique_list_page_vctl.dart';
import 'package:ateliya/views/static/modele_boutique/edition_modele_boutique_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeleListBoutiquePage extends StatelessWidget {
  const ModeleListBoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ModeleBoutiqueListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Modèles boutique",
          createPage: const EditionModeleBoutiquePage(),
          itemBuilder: (_, i, selected) => ListItem(
            ctl,
            leadingImage: (ctl.data.items[i].modele!.photo == null)
                ? "assets/images/svg/modele.svg"
                : (ctl.data.items[i].modele!.photo is FichierServer)
                    ? (ctl.data.items[i].modele!.photo as FichierServer)
                        .fullUrl!
                    : null,
            editionPage: EditionModeleBoutiquePage(item: ctl.data.items[i]),
            index: i,
            title: ctl.data.items[i].modele!.libelle.value,
            subtitle: ctl.data.items[i].quantite.toAmount(unit: "unité(s)"),
          ),
        );
      },
    );
  }
}
