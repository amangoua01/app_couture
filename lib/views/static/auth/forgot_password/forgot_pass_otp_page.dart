import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/views/static/auth/forgot_password/reset_forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class ForgotPassOtpPage extends StatelessWidget {
  const ForgotPassOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmation du OTP")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ListTile(
            title: Text(
              'Confirmation du compte',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Nous vous avons envoyé un code de confirmation par mail'
                ' contenant un code OTP. Veuillez le saisir ci-dessous.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Gap(50),
          const Pinput(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            length: 6,
            obscureText: true,
          ),
          const Gap(40),
          CButton(
            onPressed: () => Get.to(() => const ResetForgotPasswordPage()),
          ),
        ],
      ),
    );
  }
}
