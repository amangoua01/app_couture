import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/static/auth/forgot_password/forgot_password_page.dart';
import 'package:app_couture/views/static/home/home_windows.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: 180,
            child: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.greenLight2,
                child: Image.asset(
                  "assets/images/logo_ateliya.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(5),
                const Text(
                  "Connecter à l’application pour continuer",
                  style: TextStyle(fontSize: 14),
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CTextFormField(
                        externalLabel: "Numéro de téléphone",
                        hintText: "Entrer votre  numéro téléphone",
                      ),
                      const CTextFormField(
                        externalLabel: "Mot de passe",
                        hintText: "Entrer votre mot de passe",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(
                              () => const ForgotPasswordPage(),
                            ),
                            child: const Text("Mot de passe oublé ?"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(15),
                CButton(
                  title: "Se connecter",
                  onPressed: () => Get.to(() => const HomeWindows()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
