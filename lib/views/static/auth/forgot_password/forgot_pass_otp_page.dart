import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/views/controllers/auth/forgot_password/forgot_pass_otp_page_vctl.dart';
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
              Pinput(
                controller: ctl.otpCtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                length: 6,
                obscureText: true,
              ),
              const Gap(40),
              CButton(onPressed: ctl.submit),
            ],
          ),
        );
      },
    );
  }
}
