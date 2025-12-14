import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/constants/type_user_enum.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/field_set_container.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/clients/edition_client_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionClientPage extends StatelessWidget {
  final Client? item;
  const EditionClientPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionClientPageVctl(item),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Ajouter un client")),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 100,
              ),
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
                FieldSetContainer(children: [
                  CTextFormField(
                    externalLabel: "Nom",
                    require: true,
                    controller: ctl.nomCtl,
                  ),
                  CTextFormField(
                    externalLabel: "Prénom(s)",
                    require: true,
                    controller: ctl.prenomCtl,
                  ),
                  CTextFormField(
                    externalLabel: "Téléphone",
                    require: true,
                    controller: ctl.telCtl,
                  ),
                ]),
                FieldSetContainer(children: [
                  Visibility(
                    visible: [TypeUserEnum.adb, TypeUserEnum.adsb]
                            .contains(ctl.user.typeEnum) ||
                        ctl.user.isAdmin,
                    child: CDropDownFormField(
                      selectedItem: ctl.boutique,
                      items: (e, f) => ctl.fetchBoutiques(),
                      externalLabel: "Boutique",
                      itemAsString: (e) => e.libelle.value,
                      onChanged: (e) {
                        ctl.boutique = e;
                        ctl.update();
                      },
                    ),
                  ),
                  Visibility(
                    visible: [TypeUserEnum.adsb, TypeUserEnum.ads]
                            .contains(ctl.user.typeEnum) ||
                        ctl.user.isAdmin,
                    child: CDropDownFormField(
                      selectedItem: ctl.succursale,
                      externalLabel: "Succursale",
                      itemAsString: (e) => e.libelle.value,
                      items: (e, f) => ctl.fetchSuccursales(),
                      onChanged: (e) {
                        ctl.succursale = e;
                        ctl.update();
                      },
                    ),
                  ),
                ]),
                const Gap(10),
                CButton(onPressed: ctl.submit),
              ],
            ),
          ),
        );
      },
    );
  }
}
