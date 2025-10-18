import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/static/home/home_windows.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ResetForgotPasswordPage extends StatelessWidget {
  const ResetForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Réinitialisation du mot de passe")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CTextFormField(
            externalLabel: 'Nouveau mot de passe',
          ),
          const CTextFormField(
            externalLabel: 'Confirmer le nouveau mot de passe',
          ),
          const Gap(10),
          CButton(
            onPressed: () => Get.to(() => const HomeWindows()),
          ),
        ],
      ),
    );
  }
}
