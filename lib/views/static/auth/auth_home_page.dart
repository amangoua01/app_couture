import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/views/static/auth/login_page.dart';
import 'package:app_couture/views/static/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AuthHomePage extends StatelessWidget {
  const AuthHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: 350,
            child: Image.asset(
              "assets/images/deco1.png",
              fit: BoxFit.cover,
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/logo_text.png",
                  height: 40,
                ),
                const Text(
                  "Toute la gestion de  votre  Atelier en un seul endroit",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                const Gap(10),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus velit quam, venenatis non sapien et,",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const Gap(40),
                CButton(
                  title: "Se connecter",
                  onPressed: () => Get.to(() => const LoginPage()),
                ),
                const Gap(20),
                CButton(
                  color: Colors.white,
                  textColor: AppColors.primary,
                  title: "S'inscrire",
                  border: const BorderSide(color: AppColors.primary),
                  onPressed: () => Get.to(() => const RegisterPage()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
