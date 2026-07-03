import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/auth/register_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterStep2 extends StatelessWidget {
  const RegisterStep2({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterPageVctl>(builder: (ctl) {
      return Form(
        key: ctl.formKey2,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CTextFormField(
              controller: ctl.nomEntrepriseCtl,
              require: true,
              externalLabel: "Nom de l'entreprise",
              hintText: "Nom de votre atelier/boutique",
              prefixIcon: const Icon(
                Icons.business_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            CTextFormField(
              controller: ctl.emailEntrepriseCtl,
              externalLabel: "Email de l'entreprise (Optionnel)",
              hintText: "entreprise@email.com",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            CTextFormField(
              controller: ctl.telEntrepriseCtl,
              externalLabel: "Contact / Téléphone",
              hintText: "Saisir le numéro de contact",
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
      );
    });
  }
}
