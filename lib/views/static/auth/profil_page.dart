import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/static/auth/update_password_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes informations")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                Badge(
                  padding: const EdgeInsets.all(5),
                  alignment: const Alignment(.4, .7),
                  label: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                  backgroundColor: AppColors.primary,
                  child: Image.asset(
                    "assets/images/user.png",
                    width: 100,
                    color: Colors.black,
                  ),
                ),
                const Gap(10),
                const Text("PATRICK CYRILL"),
                const Text(
                  "user@email.com",
                  style: TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const CTextFormField(
            externalLabel: 'Nom',
          ),
          const CTextFormField(
            externalLabel: 'Prémom(s)',
          ),
          const CTextFormField(
            externalLabel: 'Téléphone',
          ),
          const Gap(10),
          CButton(
            title: 'Enregistrer',
            onPressed: () {},
          ),
          const Gap(40),
          GestureDetector(
            onTap: () => Get.to(() => const UpdatePasswordPage()),
            child: const Text(
              'Changer mon mot de passe >',
              style: TextStyle(color: AppColors.primary),
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}
