import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UpdatePasswordPage extends StatelessWidget {
  const UpdatePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Changer mon mot de passe")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CTextFormField(
            externalLabel: 'Ancien mot de passe',
          ),
          const CTextFormField(
            externalLabel: "Nouveau mot de passe",
          ),
          const CTextFormField(
            externalLabel: 'Confirmer le nouveau mot de passe',
          ),
          const Gap(10),
          CButton(
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
