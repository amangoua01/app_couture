import 'dart:io';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/auth/login_page_vctl.dart';
import 'package:ateliya/views/static/auth/forgot_password/forgot_password_page.dart';
import 'package:ateliya/views/static/auth/register_page.dart';
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
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.greenLight2.withAlpha(50),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: ctl.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Gap(60),
                        // Logo Section
                        Center(
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(25),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                "assets/images/logo_ateliya.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        // Welcome Text
                        const Text(
                          "Bon retour !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          "Heureux de vous revoir. Connectez-vous à votre compte.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const Gap(20),
                        // Login Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(12),
                                blurRadius: 40,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CTextFormField(
                                externalLabel: "Email",
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
                                    return "L'email est requis";
                                  } else {
                                    if (!e.value.isEmail) {
                                      return "L'email n'est pas valide";
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                              ),
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
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    "Mot de passe oublié ?",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(30),
                              CButton(
                                title: "Se connecter",
                                height: 46,
                                radius: 16,
                                fontWeight: FontWeight.w700,
                                onPressed: ctl.submit,
                              ),
                            ],
                          ),
                        ),
                        const Gap(30),
                        // Social Login or Sign Up hint
                        Visibility(
                          visible: Platform.isAndroid,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Vous n'avez pas de compte ? ",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              GestureDetector(
                                onTap: () => Get.to(() => const RegisterPage()),
                                child: const Text(
                                  "S'inscrire",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(40),
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
