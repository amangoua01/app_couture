import 'package:app_couture/tools/extensions/ternary_fn.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/body_list_view.dart';
import 'package:app_couture/tools/widgets/list_item.dart';
import 'package:app_couture/views/controllers/personnels/personnels_list_page_vctl.dart';
import 'package:app_couture/views/static/personnels/edition_personnel_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonnelListPage extends StatelessWidget {
  const PersonnelListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PersonnelsListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Personnel",
          createPage: const EditionPersonnelPage(),
          itemBuilder: (_, i, selected) => ListItem(
            ctl,
            leadingImage:
                ctl.data.items[i].photoProfil ?? "assets/images/svg/client.svg",
            displayBadge: ctl.data.items[i].isActive == true,
            backgroundColor: Colors.red,
            badgeWidget: const Icon(Icons.lock, size: 10, color: Colors.white),
            editionPage: EditionPersonnelPage(
              item: ctl.data.items[i],
            ),
            index: i,
            title: ternaryFn(
              condition: ctl.user.id == ctl.data.items[i].id,
              ifTrue: "Vous-même",
              ifFalse: ctl.data.items[i].nom.value,
            ),
            subtitle: ctl.data.items[i].login,
          ),
        );
      },
    );
  }
}
