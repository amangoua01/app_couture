import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/auth/forgot_password/forgot_password_page_vctl.dart';
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text(
              "Mot de passe oublié ?",
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: ctl.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      Center(
                        child: Image.asset(
                          "assets/images/deco2.png",
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Gap(30),
                      const Text(
                        "Récupération de compte",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const Gap(8),
                      const Text(
                        "Ne vous inquiétez pas, cela arrive. Veuillez saisir "
                        "l'adresse e-mail associée à votre compte.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                      const Gap(30),
                      CTextFormField(
                        controller: ctl.emailCtl,
                        keyboardType: TextInputType.emailAddress,
                        externalLabel: "Adresse e-mail",
                        hintText: "votre@email.com",
                        require: true,
                        prefixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
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
                      const Gap(24),
                      CButton(
                        title: "Envoyer le code",
                        height: 52,
                        radius: 12,
                        fontWeight: FontWeight.w600,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: ctl.submit,
                      ),
                      const Gap(40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Vous vous en souvenez ? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Text(
                              "Se connecter",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
