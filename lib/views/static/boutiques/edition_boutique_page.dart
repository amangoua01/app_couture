import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditionBoutiquePage extends StatelessWidget {
  const EditionBoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edition de boutique")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CTextFormField(externalLabel: "Nom"),
          const CTextFormField(externalLabel: "Contact"),
          const CTextFormField(externalLabel: "Situation géographique"),
          const Gap(10),
          CButton(
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
