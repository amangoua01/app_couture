import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditionClientPage extends StatelessWidget {
  const EditionClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un client")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          const CTextFormField(externalLabel: "Nom"),
          const CTextFormField(externalLabel: "Prénom(s)"),
          const CTextFormField(externalLabel: "Téléphone"),
          const Text("Client pour : "),
          CheckboxListTile(
            value: false,
            contentPadding: EdgeInsets.zero,
            onChanged: (e) {},
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text("Surcussale"),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: false,
            onChanged: (e) {},
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text("Boutique"),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: false,
            onChanged: (e) {},
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text("Les deux"),
          ),
          const Gap(10),
          CButton(onPressed: () {}),
        ],
      ),
    );
  }
}
