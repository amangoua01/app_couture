import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/controllers/auth/forgot_password/forgot_password_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ForgotPasswordPageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Mot de passe oublié")),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  child: Image.asset(
                    "assets/images/deco2.png",
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(5),
                      const Text(
                        "Ne vous inquiétez pas, cela arrive. Veuillez saisir"
                        " l'adresse e-mail associée à votre compte.",
                        style: TextStyle(fontSize: 14),
                      ),
                      const Gap(20),
                      CTextFormField(
                        controller: ctl.emailCtl,
                        keyboardType: TextInputType.emailAddress,
                        externalLabel: "Email",
                        hintText: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir votre adresse e-mail";
                          }
                          if (!value.value.isEmail) {
                            return "Veuillez saisir une adresse e-mail valide";
                          }
                          return null;
                        },
                      ),
                      const Gap(20),
                      CButton(
                        title: "Envoyer le code",
                        onPressed: ctl.submit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
