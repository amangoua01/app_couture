import 'package:ateliya/data/dto/autre_image_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_image_picker_field.dart';
import 'package:ateliya/tools/widgets/check_box_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mesure/edition_piece_couture_page_vctl.dart';
import 'package:flutter/cupertino.dart';
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
            title: const Text("Edition de pièce"),
            actions: [
              IconButton(
                tooltip: "Reprendre les mesures d'un client",
                icon: const Icon(Icons.history_rounded),
                onPressed: ctl.openReprendreMesuresClient,
              ),
            ],
          ),
          floatingActionButton:
              (ctl.isSurMesure && ctl.mensurations.isNotEmpty)
                  ? FloatingActionButton.extended(
                    backgroundColor:
                        ctl.isListening
                            ? Colors.red.shade800
                            : const Color(0xFFDC2626),
                    icon:
                        ctl.isProcessingSpeech
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Icon(
                              ctl.isListening ? Icons.mic_none : Icons.mic,
                              color: Colors.white,
                            ),
                    label: Text(
                      ctl.isProcessingSpeech
                          ? "Analyse..."
                          : (ctl.isListening
                              ? "Écoute en cours..."
                              : "Dicter (IA)"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed:
                        ctl.isProcessingSpeech ? null : ctl.toggleListening,
                  )
                  : null,
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.all(20).copyWith(bottom: 100),
              children: [
                CDropDownFormField(
                  selectedItem: ctl.selectedTypeMesure,
                  onChanged: ctl.onTypeMesureChanged,
                  items: (p0, p1) => ctl.fetchTypeMesures(),
                  itemAsString: (p0) => p0.libelle.value,
                  // Le type sélectionné après une dictée vocale provient
                  // d'un appel cache distinct de celui qui peuple cette
                  // liste : comparer par id plutôt que par référence évite
                  // que le dropdown paraisse vide alors qu'un type a bien
                  // été reconnu.
                  compareFn: (a, b) => a.id == b.id,
                  externalLabel: "Type pièce",
                  require: true,
                ),
                const Gap(4),
                _SurMesureToggle(ctl: ctl),
                const Gap(20),
                Visibility(
                  visible: !ctl.isSurMesure,
                  child: CDropDownFormField(
                    selectedItem: ctl.selectedTailleStandard,
                    externalLabel: "Taille",
                    onChanged: (e) {
                      ctl.selectedTailleStandard = e;
                      ctl.update();
                    },
                    items: (e, f) => ctl.fetchTailleStandards(),
                    itemAsString: (e) => e.libelle.value,
                    require: !ctl.isSurMesure,
                  ),
                ),

                if (ctl.isSurMesure && ctl.mensurations.isNotEmpty) ...[
                  const Gap(20),
                  const Text(
                    "Mensurations",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  // Une ligne par mensuration : libellé, valeur et
                  // interrupteur côte à côte, pour qu'un maximum de pièces
                  // tienne à l'écran sans défilement excessif.
                  ...ctl.mensurations.map((e) {
                    final isActive = e.isActive;
                    return AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 8),
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isActive
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                e.categorieMesure.libelle ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isActive
                                          ? AppColors.textDark
                                          : AppColors.textMuted,
                                ),
                              ),
                            ),
                            const Gap(8),
                            if (isActive)
                              Expanded(
                                flex: 4,
                                child: CTextFormField(
                                  key: ValueKey(e.valeur),
                                  hintText: 'Valeur',
                                  require: true,
                                  initialValue:
                                      e.valeur.isNotEmpty
                                          ? e.valeur.toString()
                                          : '',
                                  validator: (v) {
                                    if (e.isActive &&
                                        (v.value.isEmpty ||
                                            v == "0" ||
                                            v == "0.0")) {
                                      return "Requis";
                                    }
                                    return null;
                                  },
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  onChanged: (value) {
                                    e.valeur = value.value;
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  margin: EdgeInsets.zero,
                                ),
                              ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: isActive,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  e.isActive = val;
                                  ctl.update();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                const Gap(20),
                Container(
                  decoration: CardStyle.decoration(),
                  clipBehavior: Clip.antiAlias,
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text(
                        "Détails financiers & Pagne (Optionnel)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        CTextFormField(
                          controller: ctl.nomTenancierCtl,
                          externalLabel: "Nom tenancier",
                          textCapitalization: TextCapitalization.words,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CTextFormField(
                                controller: ctl.montantCtl,
                                keyboardType: TextInputType.number,
                                externalLabel: 'Montant',
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
                                      if (val >
                                          ctl.montantCtl.text
                                              .toDouble()
                                              .value) {
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
                        CheckBoxField(
                          title: "Le client a un tissu/pagne",
                          subtitle:
                              "Cochez cette case si le client a un tissu/pagne",
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
                                  "${ctl.autreImagesMesure.length} pagne/tissu(s)",
                                ),
                                trailing: CircleAvatar(
                                  child: IconButton(
                                    icon: const Icon(Icons.add_circle),
                                    onPressed: () {
                                      ctl.autreImagesMesure.add(
                                        AutreImageMesureDto(),
                                      );
                                      ctl.update();
                                      Future.delayed(
                                        const Duration(milliseconds: 100),
                                        () {
                                          if (ctl
                                              .autreImagesPageCtl
                                              .hasClients) {
                                            ctl.autreImagesPageCtl
                                                .animateToPage(
                                                  ctl.autreImagesMesure.length -
                                                      1,
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeOut,
                                                );
                                          }
                                        },
                                      );
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: buildImageSelection(
                                          item,
                                          i,
                                          ctl,
                                        ),
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
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        width:
                                            ctl.currentAutreImageIndex == index
                                                ? 12
                                                : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color:
                                              ctl.currentAutreImageIndex ==
                                                      index
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
                      ],
                    ),
                  ),
                ),
                const Gap(30),
                CButton(onPressed: ctl.submit),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildImageSelection(
    AutreImageMesureDto autreImage,
    int index,
    EditionPieceCouturePageVctl ctl,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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

/// Bascule entre les deux façons de chiffrer une pièce — plus visible qu'une
/// case à cocher perdue parmi les champs, et qui nomme les deux options au
/// lieu de n'en affirmer qu'une seule ("Pièce sur mesure" cochée ou non).
class _SurMesureToggle extends StatelessWidget {
  final EditionPieceCouturePageVctl ctl;
  const _SurMesureToggle({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleOption(
              icon: Icons.straighten_rounded,
              label: "Sur mesure",
              selected: ctl.isSurMesure,
              onTap: () {
                // Une taille standard choisie précédemment n'a plus de sens
                // une fois repassé en saisie libre.
                ctl.isSurMesure = true;
                ctl.selectedTailleStandard = null;
                ctl.update();
              },
            ),
          ),
          Expanded(
            child: _ToggleOption(
              icon: Icons.checkroom_rounded,
              label: "Taille standard",
              selected: !ctl.isSurMesure,
              onTap: () {
                ctl.isSurMesure = false;
                ctl.update();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppColors.primary : AppColors.textMuted,
            ),
            const Gap(6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
