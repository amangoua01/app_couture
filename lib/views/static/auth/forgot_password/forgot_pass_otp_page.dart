import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/controllers/auth/forgot_password/forgot_pass_otp_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class ForgotPassOtpPage extends StatelessWidget {
  final String email;
  const ForgotPassOtpPage(
    this.email, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ForgotPassOtpPageVctl(email),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text(
              "Confirmation du OTP",
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(40),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Gap(30),
                    const Text(
                      "Vérification du code",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Gap(8),
                    Text.rich(
                      TextSpan(
                        text:
                            "Nous vous avons envoyé un code de confirmation par e-mail à l'adresse ",
                        children: [
                          TextSpan(
                            text: email,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const TextSpan(
                            text: ". Veuillez le saisir ci-dessous.",
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    const Gap(30),
                    Pinput(
                      controller: ctl.otpCtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      length: 6,
                      defaultPinTheme: PinTheme(
                        width: 50,
                        height: 55,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 50,
                        height: 55,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const Gap(36),
                    CButton(
                      title: "Valider",
                      height: 54,
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: ctl.submit,
                    ),
                    const Gap(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Pas reçu de code ?  ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Text(
                            "Renvoyer",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
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
