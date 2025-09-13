import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/controllers/auth/register_page_vctl.dart';
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("Inscription"),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      ListView(
                        padding: const EdgeInsets.all(20),
                        children: const [
                          CDropDownFormField(externalLabel: "Pays"),
                          CTextFormField(externalLabel: "Numéro de téléphone"),
                          CTextFormField(externalLabel: "Mot de passe"),
                          CTextFormField(
                              externalLabel: "Confirmer le mot de passe"),
                        ],
                      ),
                      ListView(
                        padding: const EdgeInsets.all(20),
                        children: const [
                          CTextFormField(
                            externalLabel: "Nom de l'entreprise",
                          ),
                          CTextFormField(
                            externalLabel: "Email",
                          ),
                          CTextFormField(
                            externalLabel: "Contact",
                          ),
                        ],
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
