import 'package:ateliya/data/dto/autre_image_mesure_dto.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        title: const Text("D'autres pagnes/tissus ?"),
                        subtitle: Text(
                            "${ctl.autreImagesMesure.length} pagne/tissu(s)"),
                        trailing: CircleAvatar(
                          child: IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              ctl.autreImagesMesure.add(AutreImageMesureDto());
                              ctl.update();
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                if (ctl.autreImagesPageCtl.hasClients) {
                                  ctl.autreImagesPageCtl.animateToPage(
                                    ctl.autreImagesMesure.length - 1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      const Gap(20),
                      if (ctl.autreImagesMesure.isNotEmpty) ...[
                        SizedBox(
                          height: 330,
                          child: PageView.builder(
                            controller: ctl.autreImagesPageCtl,
                            onPageChanged: (i) {
                              ctl.currentAutreImageIndex = i;
                              ctl.update();
                            },
                            itemCount: ctl.autreImagesMesure.length,
                            itemBuilder: (context, i) {
                              final item = ctl.autreImagesMesure[i];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: buildImageSelection(item, i, ctl),
                              );
                            },
                          ),
                        ),
                        const Gap(10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              ctl.autreImagesMesure.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: ctl.currentAutreImageIndex == index
                                    ? 12
                                    : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: ctl.currentAutreImageIndex == index
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(20),
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

  Widget buildImageSelection(AutreImageMesureDto autreImage, int index,
      EditionPieceCouturePageVctl ctl) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CImagePickerField(
                    label: "Pagne/Tissu",
                    path: autreImage.pagne?.path,
                    onDelete: () {
                      autreImage.pagne = null;
                      ctl.update();
                    },
                    onChanged: (e) {
                      autreImage.pagne = e;
                      ctl.update();
                    },
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: CImagePickerField(
                    label: "Modèle",
                    path: autreImage.modele?.path,
                    onDelete: () {
                      autreImage.modele = null;
                      ctl.update();
                    },
                    onChanged: (e) {
                      autreImage.modele = e;
                      ctl.update();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Quantité :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 24),
                    color: Colors.red.shade400,
                    onPressed: () {
                      if (autreImage.quantite > 1) {
                        autreImage.quantite = autreImage.quantite - 1;
                        ctl.update();
                      }
                    },
                  ),
                  Text(
                    "${autreImage.quantite}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 24),
                    color: Colors.green.shade400,
                    onPressed: () {
                      autreImage.quantite = autreImage.quantite + 1;
                      ctl.update();
                    },
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  ctl.autreImagesMesure.removeAt(index);
                  ctl.update();
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
