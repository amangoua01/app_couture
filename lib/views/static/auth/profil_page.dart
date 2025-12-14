import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/auth/profil_page_vctl.dart';
import 'package:ateliya/views/static/auth/update_password_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProfilPageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Mes informations")),
          body: Form(
            key: ctl.formKey,
            child: ListView(
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
                      Text(ctl.user.fullName),
                      Text(
                        ctl.user.login.value,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                CTextFormField(
                  controller: ctl.nomCtl,
                  externalLabel: 'Nom',
                ),
                CTextFormField(
                  controller: ctl.prenomCtl,
                  externalLabel: 'Prémom(s)',
                  require: true,
                ),
                CTextFormField(
                  initialValue: ctl.user.login.value,
                  enabled: false,
                  externalLabel: 'Email(Non modifiable)',
                ),
                const Gap(10),
                CButton(
                  title: 'Enregistrer',
                  onPressed: ctl.submit,
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
          ),
        );
      },
    );
  }
}
