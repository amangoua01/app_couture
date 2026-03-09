import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/views/controllers/type_mesure/type_mesure_list_page_vctl.dart';
import 'package:ateliya/views/static/type_mesure/categorie_type_mesure/categorie_type_mesure_list_page.dart';
import 'package:ateliya/views/static/type_mesure/edition_type_mesure_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
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
          enableMultipleDeletion: false,
          title: "Types de mesure",
          // createPage: const EditionTypeMesurePage(),
          itemBuilder: (_, i, selected) => ListTile(
            leading: CircleAvatar(
              child: SvgPicture.asset(
                "assets/images/svg/mesure.svg",
                height: 30,
              ),
            ),
            onTap: () => Get.to(
              () => EditionTypeMesurePage(item: ctl.data.items[i]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 17,
                  child: IconButton(
                    splashRadius: 20,
                    onPressed: () => Get.to(
                      () => CategorieTypeMesureListPage(
                        ctl.data.items[i],
                      ),
                    ),
                    icon: const Icon(Icons.list_alt, size: 17),
                  ),
                ),
                const Gap(20),
                const Icon(Icons.arrow_forward_ios_rounded, size: 15),
              ],
            ),
            title: Text(ctl.data.items[i].libelle.value),
            subtitle: Text(ctl.data.items[i].categoriesString),
          ),
          // ListItem(
          //   ctl,
          //   leadingImage: "assets/images/svg/mesure.svg",
          //   deletable: ctl.data.items[i].entreprise != null,
          //   editionPage: EditionTypeMesurePage(item: ctl.data.items[i]),
          //   index: i,
          //   title: ctl.data.items[i].libelle.value,
          //   subtitle: ctl.data.items[i].categoriesString,
          //   actions: const [],
          // ),
        );
      },
    );
  }
}
