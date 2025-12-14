import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/auth/register_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RegisterPageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Inscription")),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  MaterialButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    textColor: AppColors.primary,
                    height: 40,
                    onPressed: ctl.onPrev,
                    child: const Text("Précédent"),
                  ),
                  const Spacer(),
                  MaterialButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 40,
                    textColor: Colors.white,
                    color: AppColors.primary,
                    onPressed: ctl.onNext,
                    child: const Text("Suivant"),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Inscrivez-vous pour bénéficier de toutes les fonctionnalités de Ecouture.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const Gap(30),
                    Center(
                      child: SizedBox(
                        width: Get.width / 1.5,
                        child: FlutterStepIndicator(
                          list: const [1, 2],
                          onChange: (i) {},
                          progressColor: AppColors.primary,
                          page: ctl.currentPage,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: ctl.pageCtl,
                    children: [
                      Form(
                        key: ctl.formKey1,
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            CDropDownFormField(
                              externalLabel: "Pays",
                              require: true,
                              hintText: "Sélectionner le pays",
                              selectedItem: ctl.selectedPays,
                              items: (e, f) => ctl.fetchPays(),
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
                              keyboardType: TextInputType.emailAddress,
                              validator: (e) {
                                if (!e.value.isEmail) {
                                  return "Veuillez entrer une adresse email valide";
                                }
                                return null;
                              },
                            ),
                            CTextFormField(
                              controller: ctl.passwordCtl,
                              require: true,
                              obscureText: true,
                              externalLabel: "Mot de passe",
                              hintText: "Mot de passe",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez saisir le mot de passe";
                                }
                                if (value.length < 6) {
                                  return "Le mot de passe doit contenir au moins 6 caractères";
                                }
                                return null;
                              },
                            ),
                            CTextFormField(
                              controller: ctl.confirmPasswordCtl,
                              require: true,
                              obscureText: true,
                              externalLabel: "Confirmer le mot de passe",
                              hintText: "Confirmer le mot de passe",
                              validator: (value) {
                                if (value != ctl.passwordCtl.text) {
                                  return "Les mots de passe ne correspondent pas";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: ctl.formKey2,
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            CTextFormField(
                              controller: ctl.nomEntrepriseCtl,
                              require: true,
                              externalLabel: "Nom de l'entreprise",
                            ),
                            CTextFormField(
                              controller: ctl.emailEntrepriseCtl,
                              require: true,
                              externalLabel: "Email",
                            ),
                            CTextFormField(
                              controller: ctl.telEntrepriseCtl,
                              require: true,
                              externalLabel: "Contact",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
