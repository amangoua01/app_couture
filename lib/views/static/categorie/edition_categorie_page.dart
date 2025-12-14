import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/tools/widgets/body_edition_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/categorie/edition_categorie_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionCategoriePage extends StatelessWidget {
  final CategorieMesure? item;
  const EditionCategoriePage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionCategoriePageVctl(item),
      builder: (ctl) => BodyEditionPage(
        ctl,
        module: "catégorie",
        children: [
          CTextFormField(
            controller: ctl.libelleCtl,
            externalLabel: "Libellé",
          ),
        ],
      ),
    );
  }
}
