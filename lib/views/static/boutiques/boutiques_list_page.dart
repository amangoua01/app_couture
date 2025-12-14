import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/boutiques/boutiques_list_page_vctl.dart';
import 'package:ateliya/views/static/boutiques/edition_boutique_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoutiquesListPage extends StatelessWidget {
  const BoutiquesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BoutiquesListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Boutiques",
          createPage: const EditionBoutiquePage(),
          itemBuilder: (_, i, selected) => ListItem(
            ctl,
            leadingImage: "assets/images/svg/boutique.svg",
            editionPage: EditionBoutiquePage(item: ctl.data.items[i]),
            index: i,
            title: ctl.data.items[i].libelle.value,
            subtitle: ctl.data.items[i].contact,
          ),
        );
      },
    );
  }
}
