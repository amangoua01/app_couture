import 'package:app_couture/data/models/succursale.dart';
import 'package:app_couture/tools/widgets/body_edition_page.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/controllers/sucursales/edition_surcusale_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionSurcusalePage extends StatelessWidget {
  final Succursale? item;
  const EditionSurcusalePage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionSurcusalePageVctl(item),
      builder: (ctl) {
        return BodyEditionPage(
          ctl,
          module: "surcusale",
          children: [
            CTextFormField(
              externalLabel: "Nom",
              require: true,
              controller: ctl.libelleCtl,
            ),
            CTextFormField(
              externalLabel: "Contact",
              controller: ctl.contactCtl,
            ),
          ],
        );
      },
    );
  }
}
