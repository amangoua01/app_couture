import 'dart:io';

import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/print/add_printer_from_adresse_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddPrinterFromAdressePage extends StatelessWidget {
  const AddPrinterFromAdressePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddPrinterFromAdressePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Ajouter une imprimante")),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const ListTile(
                title: Text(
                  "Ajouter une imprimante manuellement",
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(20),
              CTextFormField(
                controller: ctl.adresseCtl,
                labelText: "Adresse",
                hintText: ternaryFn(
                  condition: Platform.isAndroid,
                  ifTrue: '##:##:##:##:##:##',
                  ifFalse: '########-####-####-####-############',
                ),
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: ternaryFn(
                      condition: Platform.isAndroid,
                      ifTrue: '##:##:##:##:##:##',
                      ifFalse: '########-####-####-####-############',
                    ),
                    filter: {"#": RegExp(r'[A-Fa-f0-9]')},
                    type: MaskAutoCompletionType.eager,
                  ),
                ],
              ),
              CButton(
                title: "Connecter",
                onPressed: ctl.connect,
              ),
            ],
          ),
        );
      },
    );
  }
}
