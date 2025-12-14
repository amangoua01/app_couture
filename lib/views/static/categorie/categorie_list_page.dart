import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/categorie/categorie_list_page_vctl.dart';
import 'package:ateliya/views/static/categorie/edition_categorie_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorieListPage extends StatelessWidget {
  const CategorieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CategorieListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Catégories",
          createPage: const EditionCategoriePage(),
          itemBuilder: (_, i, selected) => ListItem(ctl,
              leadingImage: "assets/images/svg/categorie.svg",
              editionPage: EditionCategoriePage(item: ctl.data.items[i]),
              index: i,
              title: ctl.data.items[i].libelle.value),
        );
      },
    );
  }
}
