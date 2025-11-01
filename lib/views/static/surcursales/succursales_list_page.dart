import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/body_list_view.dart';
import 'package:app_couture/tools/widgets/list_item.dart';
import 'package:app_couture/views/controllers/succursales/succursales_list_page_vctl.dart';
import 'package:app_couture/views/static/surcursales/edition_surcusale_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccursalesListPage extends StatelessWidget {
  const SuccursalesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SuccursalesListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Succursales",
          createPage: const EditionSurcusalePage(),
          itemBuilder: (_, i, selected) => ListItem(
            ctl,
            leadingImage: "assets/images/svg/store.svg",
            editionPage: EditionSurcusalePage(item: ctl.data.items[i]),
            index: i,
            title: ctl.data.items[i].libelle.value,
            subtitle: ctl.data.items[i].contact,
          ),
        );
      },
    );
  }
}
