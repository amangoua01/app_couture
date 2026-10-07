import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/ateliers/ateliers_list_page_vctl.dart';
import 'package:ateliya/views/static/ateliers/edition_atelier_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AteliersListPage extends StatelessWidget {
  const AteliersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AteliersListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Ateliers",
          createPage: const EditionAtelierPage(),
          itemBuilder:
              (_, i, selected) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.15), width: 1.5),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListItem(
                    ctl,
                    leadingImage: "assets/images/svg/store.svg",
                    editionPage: EditionAtelierPage(item: ctl.data.items[i]),
                    index: i,
                    title: ctl.data.items[i].libelle.value,
                    subtitle: ctl.data.items[i].contact,
                  ),
                ),
              ),
        );
      },
    );
  }
}
