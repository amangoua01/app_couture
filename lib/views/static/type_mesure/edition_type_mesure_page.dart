import 'package:ateliya/api/type_mesure_api.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/widgets/body_edition_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/views/controllers/type_mesure/edition_type_mesure_page_vctl.dart';
import 'package:ateliya/views/static/type_mesure/categorie_type_mesure/categorie_type_mesure_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditionTypeMesurePage extends StatelessWidget {
  final TypeMesure? item;

  const EditionTypeMesurePage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionTypeMesurePageVctl(item, api: TypeMesureApi()),
      builder: (ctl) {
        return BodyEditionPage(
          ctl,
          module: "type de mesure",
          readOnly: item?.entreprise == null,
          children: [
            CTextFormField(
              externalLabel: "Nom du type",
              controller: ctl.libelleCtl,
            ),
            PlaceholderBuilder(
              condition: item != null,
              builder: () {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: SvgPicture.asset(
                      "assets/images/svg/categorie.svg",
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  title: const Text("Catégories de mesures"),
                  subtitle: const Text("Modifier les catégories de "
                      "mesures associés à ce type."),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => Get.to(
                    () => CategorieTypeMesureListPage(item!),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
