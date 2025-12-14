import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele.dart';
import 'package:ateliya/tools/widgets/body_edition_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/modele/edition_modele_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionModelePage extends StatelessWidget {
  final Modele? item;
  const EditionModelePage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionModelePageVctl(item),
      builder: (ctl) => BodyEditionPage(
        ctl,
        module: "modèle",
        item: item,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => ctl.pickPhoto(),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: (ctl.photo == null)
                      ? null
                      : (ctl.photo is FichierServer)
                          ? NetworkImage(
                              (ctl.photo as FichierServer).fullUrl!,
                            )
                          : FileImage(
                              (ctl.photo as FichierLocal).file,
                            ) as ImageProvider,
                  child: Visibility(
                    visible: ctl.photo == null,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              color: Colors.grey, size: 30),
                          Text(
                            "Ajouter une photo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          CTextFormField(
            externalLabel: "Libellé",
            controller: ctl.libelleCtl,
          ),
        ],
      ),
    );
  }
}
