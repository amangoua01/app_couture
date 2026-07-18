import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/controllers/auth/register_page_vctl.dart';
import 'package:ateliya/views/static/auth/register/register_step1.dart';
import 'package:ateliya/views/static/auth/register/register_step2.dart';
import 'package:flutter/material.dart';
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
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const Gap(12),
                          const Text(
                            'Inscription',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Text(
                        ctl.currentPage == 0
                            ? "Créez votre compte pour gérer votre atelier facilement."
                            : "Dernière étape ! Parlez-nous de votre entreprise.",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 4,
                              decoration: BoxDecoration(
                                color: ctl.currentPage == 1
                                    ? AppColors.secondary
                                    : Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Étape ${ctl.currentPage + 1}/2",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ctl.currentPage == 0
                                ? "Identifiants"
                                : "Entreprise",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: ctl.pageCtl,
                  children: const [
                    RegisterStep1(),
                    RegisterStep2(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ctl.currentPage == 0
                    ? CButton(
                        title: "Suivant",
                        height: 54,
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: ctl.onNext,
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CButton(
                              title: "Retour",
                              color: Colors.white,
                              textColor: AppColors.primary,
                              border: const BorderSide(
                                  color: AppColors.primary, width: 1.5),
                              height: 54,
                              radius: 14,
                              fontWeight: FontWeight.w600,
                              onPressed: ctl.onPrev,
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            flex: 2,
                            child: CButton(
                              title: "S'inscrire",
                              color: AppColors.secondary,
                              textColor: Colors.white,
                              height: 54,
                              radius: 14,
                              fontWeight: FontWeight.w700,
                              icon: const Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: ctl.onNext,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
