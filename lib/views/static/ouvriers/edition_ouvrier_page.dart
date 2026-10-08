import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/tools/widgets/body_edition_page.dart';
import 'package:ateliya/tools/widgets/field_set_container.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/ouvriers/edition_ouvrier_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionOuvrierPage extends StatelessWidget {
  final Employe? item;
  const EditionOuvrierPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionOuvrierPageVctl(item),
      builder: (ctl) {
        return BodyEditionPage(
          ctl,
          item: item,
          module: "ouvrier",
          children: [
            FieldSetContainer(
              children: [
                CTextFormField(
                  externalLabel: "Nom",
                  controller: ctl.nomCtl,
                  require: true,
                  textCapitalization: TextCapitalization.words,
                ),
                CTextFormField(
                  externalLabel: "Prénom(s)",
                  controller: ctl.prenomsCtl,
                  textCapitalization: TextCapitalization.words,
                ),
                CTextFormField(
                  externalLabel: "Téléphone",
                  controller: ctl.telephoneCtl,
                  keyboardType: TextInputType.phone,
                ),
                CTextFormField(
                  externalLabel: "Poste",
                  hintText: "Ex: Tailleur, Brodeur...",
                  controller: ctl.posteCtl,
                ),
                CTextFormField(
                  externalLabel: "Tarif par pièce",
                  hintText: "S'il est payé à la pièce",
                  controller: ctl.tarifPieceCtl,
                  keyboardType: TextInputType.number,
                ),
                CDropDownFormField<Atelier>(
                  externalLabel: "Atelier de rattachement",
                  hintText: "Choisir l'atelier",
                  selectedItem: ctl.selectedAtelier,
                  items: (filter, _) => ctl.getAteliers(),
                  itemAsString: (a) => a.libelle ?? "",
                  compareFn: (a, b) => a.id == b.id,
                  onChanged: (a) => ctl.selectedAtelier = a,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
