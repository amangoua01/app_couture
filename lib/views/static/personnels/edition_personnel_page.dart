import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/constants/type_user_enum.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/body_edition_page.dart';
import 'package:app_couture/tools/widgets/field_set_container.dart';
import 'package:app_couture/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/controllers/personnels/edition_personnel_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionPersonnelPage extends StatelessWidget {
  final User? item;
  const EditionPersonnelPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: EditionPersonnelPageVctl(item),
        builder: (ctl) {
          return BodyEditionPage(
            ctl,
            item: item,
            module: "personnel",
            children: [
              FieldSetContainer(
                children: [
                  CTextFormField(
                    externalLabel: "Nom",
                    controller: ctl.nomCtl,
                    require: true,
                  ),
                  CTextFormField(
                    externalLabel: "Prénom(s)",
                    controller: ctl.prenomCtl,
                    require: true,
                  ),
                  Visibility(
                    visible: item == null,
                    child: CTextFormField(
                      externalLabel: "Email",
                      controller: ctl.emailCtl,
                      require: true,
                    ),
                  ),
                  CDropDownFormField(
                    enabled: item?.isAdmin == false || item == null,
                    externalLabel: "Type d'utilisateur",
                    selectedItem: ctl.typeUser,
                    items: (e, f) => ctl.getTypeUsers(),
                    require: true,
                    itemAsString: (e) => e.libelle.value,
                    onChanged: (e) {
                      ctl.typeUser = e;
                      ctl.boutique = null;
                      ctl.succursale = null;
                      ctl.update();
                    },
                  ),
                ],
              ),
              Visibility(
                visible: item == null,
                child: FieldSetContainer(
                  children: [
                    CTextFormField(
                      externalLabel: "Mot de passe",
                      controller: ctl.passwordCtl,
                      require: true,
                      obscureText: true,
                    ),
                    CTextFormField(
                      externalLabel: "Confirmation du mot de passe",
                      controller: ctl.confirmPasswordCtl,
                      require: true,
                      obscureText: true,
                      validator: (e) {
                        if (e.value.isEmpty) {
                          return "Ce champ est obligatoire";
                        } else {
                          if (e.value != ctl.passwordCtl.text) {
                            return "Le mot de passe ne correspond pas";
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (item?.isAdmin == false || item == null),
                child: FieldSetContainer(
                  children: [
                    Visibility(
                      visible: [TypeUserEnum.adb, TypeUserEnum.adsb]
                          .contains(ctl.typeUser?.typeEnum),
                      child: CDropDownFormField(
                        externalLabel: "Boutique",
                        enabled: [TypeUserEnum.adb, TypeUserEnum.adsb]
                                .contains(ctl.typeUser?.typeEnum) ||
                            item?.isAdmin == false,
                        require: [TypeUserEnum.adb, TypeUserEnum.adsb]
                            .contains(ctl.typeUser?.typeEnum),
                        selectedItem: ctl.boutique,
                        items: (e, f) => ctl.getBoutiques(),
                        itemAsString: (e) => e.libelle.value,
                        onChanged: (e) {
                          ctl.boutique = e;
                          ctl.update();
                        },
                      ),
                    ),
                    Visibility(
                      visible: [TypeUserEnum.ads, TypeUserEnum.adsb]
                          .contains(ctl.typeUser?.typeEnum),
                      child: CDropDownFormField(
                        enabled: [TypeUserEnum.ads, TypeUserEnum.adsb]
                            .contains(ctl.typeUser?.typeEnum),
                        require: [TypeUserEnum.ads, TypeUserEnum.adsb]
                            .contains(ctl.typeUser?.typeEnum),
                        externalLabel: "Surcusale",
                        items: (e, f) => ctl.getSuccursales(),
                        selectedItem: ctl.succursale,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
    // Scaffold(
    //   appBar: AppBar(title: const Text("Edition de personnel")),
    //   body: ListView(
    //     padding:
    //         const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 100),
    //     children: [
    //       const FieldSetContainer(
    //         children: [
    //           CTextFormField(externalLabel: "Nom"),
    //           CTextFormField(externalLabel: "Prénom(s)"),
    //           CDropDownFormField(externalLabel: "Type d'utilisateur"),
    //         ],
    //       ),
    //       Visibility(
    //         visible: item == null,
    //         child: const FieldSetContainer(
    //           children: [
    //             CTextFormField(externalLabel: "Mot de passe"),
    //             CTextFormField(externalLabel: "Confirmation du mot de passe"),
    //           ],
    //         ),
    //       ),
    //       const FieldSetContainer(
    //         children: [
    //           CDropDownFormField(externalLabel: "Boutique"),
    //           CDropDownFormField(externalLabel: "Surcusale"),
    //         ],
    //       ),
    //       const Gap(10),
    //       CButton(
    //         onPressed: () {},
    //       )
    //     ],
    //   ),
    // );
  }
}
