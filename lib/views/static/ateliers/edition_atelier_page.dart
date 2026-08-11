import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/tools/widgets/body_edition_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/ateliers/edition_atelier_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionAtelierPage extends StatelessWidget {
  final Atelier? item;
  const EditionAtelierPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionAtelierPageVctl(item),
      builder: (ctl) {
        return BodyEditionPage(
          ctl,
          module: "atelier",
          children: [
            CTextFormField(
              externalLabel: "Nom",
              require: true,
              controller: ctl.libelleCtl,
            ),
            CTextFormField(
              externalLabel: "Contact",
              controller: ctl.contactCtl,
              keyboardType: TextInputType.number,
            ),
          ],
        );
      },
    );
  }
}
