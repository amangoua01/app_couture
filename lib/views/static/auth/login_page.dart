import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/auth/login_page_vctl.dart';
import 'package:ateliya/views/static/auth/forgot_password/forgot_password_page.dart';
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.greenLight2,
                      child: Image.asset(
                        "assets/images/logo_ateliya.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Connexion",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(5),
                      const Text(
                        "Connecter à l’application pour continuer",
                        style: TextStyle(fontSize: 14),
                      ),
                      const Gap(20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CTextFormField(
                              externalLabel: "Email",
                              hintText: "Entrer votre email",
                              keyboardType: TextInputType.emailAddress,
                              controller: ctl.loginCtl,
                              require: true,
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
                              hintText: "Entrer votre mot de passe",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  ctl.passwordHide = !ctl.passwordHide;
                                  ctl.update();
                                },
                                icon: Icon(
                                  ternaryFn(
                                    condition: ctl.passwordHide,
                                    ifTrue: Icons.visibility,
                                    ifFalse: Icons.visibility_off,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.to(
                                    () => const ForgotPasswordPage(),
                                  ),
                                  child: const Text("Mot de passe oublé ?"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(15),
                      CButton(
                        title: "Se connecter",
                        onPressed: ctl.submit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
