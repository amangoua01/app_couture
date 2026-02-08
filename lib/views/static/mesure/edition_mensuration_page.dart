import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mesure/edition_mensuration_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionMensurationPage extends StatelessWidget {
  final LigneMesureDto ligne;
  const EditionMensurationPage(this.ligne, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionMensurationPageVctl(ligne),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edition de mensuration"),
          ),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ctl.mensurations
                      .map(
                        (e) => Row(
                          children: [
                            Expanded(
                              child: CTextFormField(
                                externalLabel: e.categorieMesure.libelle,
                                require: true,
                                enabled: e.isActive,
                                initialValue: e.valeur.toString(),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                onChanged: (value) {
                                  e.valeur = value.toDouble().value;
                                },
                                suffix: const Text("CM"),
                              ),
                            ),
                            Checkbox(
                              value: e.isActive,
                              onChanged: (value) {
                                e.isActive = value!;
                                ctl.update();
                              },
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
                const Gap(20),
                CButton(onPressed: ctl.submit),
              ],
            ),
          ),
        );
      },
    );
  }
}
