import 'dart:io';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/auth/login_page_vctl.dart';
import 'package:ateliya/views/static/auth/forgot_password/forgot_password_page.dart';
import 'package:ateliya/views/static/auth/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: ctl.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(50),
                        Center(
                          child: Image.asset(
                            "assets/images/logo_ateliya.png",
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Gap(30),
                        const Text(
                          "Connexion",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const Gap(6),
                        const Text(
                          "Entrez vos identifiants pour accéder à votre espace.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const Gap(10),
                        CTextFormField(
                          externalLabel: "Adresse e-mail",
                          hintText: "votre@email.com",
                          keyboardType: TextInputType.emailAddress,
                          controller: ctl.loginCtl,
                          require: true,
                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          validator: (e) {
                            if (e == null || e.isEmpty) {
                              return "L'adresse e-mail est requise";
                            } else if (!e.value.isEmail) {
                              return "L'adresse e-mail n'est pas valide";
                            }
                            return null;
                          },
                        ),
                        const Gap(12),
                        CTextFormField(
                          controller: ctl.passwordCtl,
                          obscureText: ctl.passwordHide,
                          require: true,
                          externalLabel: "Mot de passe",
                          hintText: "••••••••",
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              ctl.passwordHide = !ctl.passwordHide;
                              ctl.update();
                            },
                            icon: Icon(
                              ternaryFn(
                                condition: ctl.passwordHide,
                                ifTrue: Icons.visibility_outlined,
                                ifFalse: Icons.visibility_off_outlined,
                              ),
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.to(
                              () => const ForgotPasswordPage(),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const Gap(30),
                        CButton(
                          title: "Se connecter",
                          height: 52,
                          radius: 12,
                          fontWeight: FontWeight.w600,
                          onPressed: ctl.submit,
                        ),
                        const Gap(32),
                        Visibility(
                          visible: Platform.isAndroid,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Vous n'avez pas de compte ? ",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.to(() => const RegisterPage()),
                                child: const Text(
                                  "S'inscrire",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(24),
                      ],
                    ),
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
