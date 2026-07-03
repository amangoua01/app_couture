import 'dart:io';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/static/auth/login_page.dart';
import 'package:ateliya/views/static/auth/register/register_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AuthHomePage extends StatelessWidget {
  const AuthHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              flex: 11,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/deco1.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/logo_text.png",
                            height: 40,
                          ),
                        ),
                        const Gap(15),
                        const Text(
                          "Toute la gestion de votre atelier en un seul endroit",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            height: 1.3,
                          ),
                        ),
                        const Gap(12),
                        Container(
                          width: 40,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const Gap(12),
                        const Text(
                          "Une solution pensée pour les ateliers et petites entreprises : suivez vos activités, maîtrisez vos stocks et développez votre business.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CButton(
                          height: 54,
                          title: "Se connecter",
                          onPressed: () => Get.to(() => const LoginPage()),
                        ),
                        const Gap(12),
                        Visibility(
                          visible: Platform.isAndroid || kDebugMode,
                          child: CButton(
                            color: Colors.white,
                            textColor: AppColors.primary,
                            title: "S'inscrire",
                            border: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            onPressed: () => Get.to(() => const RegisterPage()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
