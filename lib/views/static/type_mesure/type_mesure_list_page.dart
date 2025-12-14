import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/type_mesure/type_mesure_list_page_vctl.dart';
import 'package:ateliya/views/static/type_mesure/edition_type_mesure_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypeMesureListPage extends StatelessWidget {
  const TypeMesureListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TypeMesureListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Types de mesure",
          createPage: const EditionTypeMesurePage(),
          itemBuilder: (_, i, selected) => ListItem(
            ctl,
            leadingImage: "assets/images/svg/mesure.svg",
            deletable: ctl.data.items[i].entreprise != null,
            editionPage: EditionTypeMesurePage(item: ctl.data.items[i]),
            index: i,
            title: ctl.data.items[i].libelle.value,
            subtitle: ctl.data.items[i].categoriesString,
          ),
        );
      },
    );
  }
}
