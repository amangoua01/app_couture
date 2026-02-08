import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_edition_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
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
        readOnly: !ctl.user.isAdmin,
        item: item,
        children: [
          Row(
            children: [
              Container(
                width: 145,
                height: 145,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: PlaceholderBuilder(
                  placeholder: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 30,
                  ),
                  condition: ctl.modele?.photo != null,
                  builder: () {
                    return Image.network(
                      (ctl.modele!.photo as FichierServer).fullUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                            size: 60,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const Gap(20),
          CDropDownFormField(
            externalLabel: "Modèle",
            selectedItem: ctl.modele,
            enabled: ctl.user.isAdmin,
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
            enabled: ctl.user.isAdmin,
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
            enabled: ctl.user.isAdmin,
            require: true,
          ),
          CTextFormField(
            externalLabel: "Prix",
            controller: ctl.prixCtl,
            require: true,
            enabled: ctl.user.isAdmin,
            keyboardType: TextInputType.number,
          ),
          CTextFormField(
            externalLabel: "Prix minimal",
            controller: ctl.prixMinimalCtl,
            require: true,
            enabled: ctl.user.isAdmin,
            keyboardType: TextInputType.number,
          ),
          Visibility(
            visible: ctl.item == null,
            child: CTextFormField(
              externalLabel: "Quantité",
              controller: ctl.quantiteCtl,
              enabled: ctl.user.isAdmin,
              require: true,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
