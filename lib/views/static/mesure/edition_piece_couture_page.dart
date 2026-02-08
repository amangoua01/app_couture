import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_image_picker_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mesure/edition_piece_couture_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionPieceCouturePage extends StatelessWidget {
  final LigneMesureDto? ligne;

  const EditionPieceCouturePage({super.key, this.ligne});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionPieceCouturePageVctl(ligne),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edition de pièce à coudre"),
          ),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CDropDownFormField(
                  selectedItem: ctl.selectedTypeMesure,
                  onChanged: (e) {
                    ctl.selectedTypeMesure = e;
                    ctl.update();
                  },
                  items: (p0, p1) => ctl.fetchTypeMesures(),
                  itemAsString: (p0) => p0.libelle.value,
                  externalLabel: "Type mesure",
                  require: true,
                ),
                CTextFormField(
                  controller: ctl.nomTenancierCtl,
                  externalLabel: "Nom tenantier",
                  textCapitalization: TextCapitalization.words,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CTextFormField(
                        controller: ctl.montantCtl,
                        keyboardType: TextInputType.number,
                        externalLabel: 'Montant',
                        require: true,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: CTextFormField(
                        controller: ctl.remiseCtl,
                        externalLabel: 'Remise',
                        keyboardType: TextInputType.number,
                        validator: (e) {
                          if (e != null && e.isNotEmpty) {
                            final val = double.tryParse(e);
                            if (val == null) {
                              return "Veuillez entrer un nombre valide";
                            } else {
                              if (val > ctl.montantCtl.text.toDouble().value) {
                                return "La remise ne peut pas être supérieure au montant";
                              }
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Le client a un tissu/pagne"),
                  subtitle: const Text(
                    "Cochez cette case si le client a un tissu/pagne",
                  ),
                  value: ctl.hasImagePagne,
                  onChanged: (e) {
                    if (e == false) {
                      ctl.pagneImageFile = null;
                      ctl.modeleImageFile = null;
                    }
                    ctl.hasImagePagne = e ?? false;
                    ctl.update();
                  },
                ),
                const Gap(20),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                        child: CImagePickerField(
                          label: "Image du pagne/tissu",
                          path: ctl.pagneImageFile?.path,
                          onDelete: () {
                            ctl.pagneImageFile = null;
                            ctl.update();
                          },
                          onChanged: (e) {
                            ctl.pagneImageFile = e;
                            ctl.update();
                          },
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        child: CImagePickerField(
                          label: "Image modèle",
                          path: ctl.modeleImageFile?.path,
                          onDelete: () {
                            ctl.modeleImageFile = null;
                            ctl.update();
                          },
                          onChanged: (e) {
                            ctl.modeleImageFile = e;
                            ctl.update();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                CTextFormField(
                  controller: ctl.descriptionCtl,
                  externalLabel: "Description",
                  maxLines: 3,
                ),
                CButton(onPressed: ctl.submit),
              ],
            ),
          ),
        );
      },
    );
  }
}
