import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mot de passe oublié")),
      body: ListView(
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
                const CTextFormField(
                  externalLabel: "Email",
                  hintText: "Email",
                ),
                const Gap(20),
                CButton(title: "Envoyer le code", onPressed: () {})
              ],
            ),
          ),
        ],
      ),
    );
  }
}
