import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/tools/widgets/body_edition_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/boutiques/edition_boutique_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class EditionBoutiquePage extends StatelessWidget {
  final Boutique? item;
  const EditionBoutiquePage({this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionBoutiquePageVctl(item),
      builder: (ctl) {
        return BodyEditionPage(
          ctl,
          module: "Boutique",
          item: item,
          children: [
            CTextFormField(
              externalLabel: "Nom",
              controller: ctl.nomCtl,
              require: true,
            ),
            CTextFormField(
              externalLabel: "Contact",
              controller: ctl.contactCtl,
              require: true,
              keyboardType: TextInputType.phone,
            ),
            CTextFormField(
              externalLabel: "Situation géographique",
              controller: ctl.situationCtl,
            ),
          ],
        );
      },
    );
  }
}
