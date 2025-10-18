import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditionSurcusalePage extends StatelessWidget {
  const EditionSurcusalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edition de surcusale")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CTextFormField(externalLabel: "Nom"),
          const CTextFormField(externalLabel: "Contact"),
          const Gap(10),
          CButton(
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
