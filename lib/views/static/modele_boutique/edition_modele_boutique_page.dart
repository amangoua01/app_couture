import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_edition_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/modele_boutique/edition_modele_boutique_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionModeleBoutiquePage extends StatelessWidget {
  final ModeleBoutique? item;
  const EditionModeleBoutiquePage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionModeleBoutiquePageVctl(item),
      builder: (ctl) => BodyEditionPage(
        ctl,
        module: "modèle boutique",
        item: item,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (ctl.modele?.photo == null)
                    ? null
                    : NetworkImage(
                        (ctl.modele!.photo as FichierServer).fullUrl!,
                      ),
                child: Visibility(
                  visible: ctl.modele?.photo == null,
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          CDropDownFormField(
            externalLabel: "Modèle",
            selectedItem: ctl.modele,
            itemAsString: (p0) => p0.libelle.value,
            require: true,
            items: (p0, p1) => ctl.getModeles(),
            onChanged: (p0) {
              ctl.modele = p0;
              ctl.update();
            },
          ),
          CDropDownFormField<Boutique>(
            externalLabel: "Boutique",
            selectedItem: ctl.boutique,
            require: true,
            items: (p0, p1) => ctl.getBoutiques(),
            onChanged: (p0) {
              ctl.boutique = p0;
              ctl.update();
            },
            itemAsString: (p0) => p0.libelle.value,
          ),
          CTextFormField(
            externalLabel: "Taille",
            controller: ctl.tailleCtl,
            require: true,
          ),
          CTextFormField(
            externalLabel: "Prix",
            controller: ctl.prixCtl,
            require: true,
            keyboardType: TextInputType.number,
          ),
          Visibility(
            visible: ctl.item == null,
            child: CTextFormField(
              externalLabel: "Quantité",
              controller: ctl.quantiteCtl,
              require: true,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
