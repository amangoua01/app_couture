import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditionPersonnelPage extends StatelessWidget {
  const EditionPersonnelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edition de personnel")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CTextFormField(externalLabel: "Nom"),
          const CTextFormField(externalLabel: "Prénom(s)"),
          const CTextFormField(externalLabel: "Mot de passe"),
          const CTextFormField(externalLabel: "Confirmation du mot de passe"),
          const CDropDownFormField(externalLabel: "Type d'utilisateur"),
          const CDropDownFormField(externalLabel: "Boutique"),
          const CDropDownFormField(externalLabel: "Surcusale"),
          const Gap(10),
          CButton(
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
