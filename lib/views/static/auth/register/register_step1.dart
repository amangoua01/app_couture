import 'package:ateliya/data/models/pays.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/auth/register_page_vctl.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class RegisterStep1 extends StatelessWidget {
  const RegisterStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterPageVctl>(builder: (ctl) {
      return Form(
        key: ctl.formKey1,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Gap(10),
            CDropDownFormField<Pays>(
              externalLabel: "Pays",
              require: true,
              hintText: "Sélectionner le pays",
              selectedItem: ctl.selectedPays,
              prefixIcon: ctl.selectedPays == null
                  ? const Icon(
                      Icons.public_rounded,
                      color: AppColors.primary,
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: CountryFlag.fromCountryCode(
                            ctl.selectedPays!.code.value,
                            theme: const ImageTheme(
                              width: 24,
                              height: 16,
                            ),
                          ),
                        ),
                        const Gap(10),
                      ],
                    ),
              items: (e, f) => ctl.fetchPays(),
              popupProps: PopupProps.menu(
                showSearchBox: false,
                fit: FlexFit.loose,
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  margin: const EdgeInsets.only(top: 8),
                ),
                itemBuilder: (context, item, isDisabled, isSelected) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.05)
                          : null,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: CountryFlag.fromCountryCode(
                            item.code.value,
                            theme: const ImageTheme(
                              width: 28,
                              height: 18,
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            item.libelle.value,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                      ],
                    ),
                  );
                },
              ),
              onChanged: (e) {
                ctl.selectedPays = e;
                ctl.update();
              },
              itemAsString: (e) => e.libelle.value,
            ),
            CTextFormField(
              controller: ctl.emailCtl,
              require: true,
              externalLabel: "Email",
              hintText: "votre@email.com",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.primary,
              ),
              validator: (e) {
                if (!e.value.isEmail) {
                  return "Veuillez entrer une adresse email valide";
                }
                return null;
              },
            ),
            CTextFormField(
              controller: ctl.codeParrainCtl,
              externalLabel: "Code parrain (Optionnel)",
              hintText: "Saisir un code de parrainage",
              prefixIcon: const Icon(
                Icons.people_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon:
                    const Icon(Icons.qr_code_scanner, color: AppColors.primary),
                onPressed: () async {
                  final res =
                      await Get.to(() => const SimpleBarcodeScannerPage());
                  if (res is String && res != '-1') {
                    ctl.codeParrainCtl.text = res;
                  }
                },
              ),
            ),
            CTextFormField(
              controller: ctl.passwordCtl,
              require: true,
              obscureText: ctl.showPassword,
              externalLabel: "Mot de passe",
              hintText: "••••••••",
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez saisir le mot de passe";
                }
                if (value.length < 6) {
                  return "Le mot de passe doit contenir au moins 6 caractères";
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  ctl.showPassword = !ctl.showPassword;
                  ctl.update();
                },
                icon: Icon(
                  ternaryFn(
                    condition: ctl.showPassword,
                    ifTrue: Icons.remove_red_eye,
                    ifFalse: Icons.visibility_off,
                  ),
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
            CTextFormField(
              controller: ctl.confirmPasswordCtl,
              require: true,
              obscureText: ctl.showConfirmPassword,
              externalLabel: "Confirmer le mot de passe",
              hintText: "••••••••",
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              validator: (value) {
                if (value != ctl.passwordCtl.text) {
                  return "Les mots de passe ne correspondent pas";
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  ctl.showConfirmPassword = !ctl.showConfirmPassword;
                  ctl.update();
                },
                icon: Icon(
                  ternaryFn(
                    condition: ctl.showConfirmPassword,
                    ifTrue: Icons.remove_red_eye,
                    ifFalse: Icons.visibility_off,
                  ),
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
