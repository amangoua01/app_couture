import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/controllers/auth/forgot_password/reset_forgot_password_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ResetForgotPasswordPage extends StatelessWidget {
  final String email;
  final String otp;
  const ResetForgotPasswordPage(this.email, this.otp, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ResetForgotPasswordPageVctl(email, otp),
        builder: (ctl) {
          return Scaffold(
            appBar:
                AppBar(title: const Text("Réinitialisation du mot de passe")),
            body: Form(
              key: ctl.formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  CTextFormField(
                    controller: ctl.newPasswordCtl,
                    obscureText: true,
                    externalLabel: 'Nouveau mot de passe',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez saisir le nouveau mot de passe";
                      }
                      if (value.length < 6) {
                        return "Le mot de passe doit contenir au moins 6 caractères";
                      }
                      return null;
                    },
                  ),
                  CTextFormField(
                    controller: ctl.confirmPasswordCtl,
                    obscureText: true,
                    externalLabel: 'Confirmer le nouveau mot de passe',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez confirmer le nouveau mot de passe";
                      }
                      if (value != ctl.newPasswordCtl.text) {
                        return "Les mots de passe ne correspondent pas";
                      }
                      return null;
                    },
                  ),
                  const Gap(10),
                  CButton(
                    onPressed: ctl.submit,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
