import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/static/auth/forgot_password/reset_forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassOtpPageVctl extends GetxController {
  final String email;
  final otpCtl = TextEditingController();
  final api = AuthApi();

  ForgotPassOtpPageVctl(this.email);

  Future<void> submit() async {
    final otp = otpCtl.text.trim();
    if (otp.isNotEmpty) {
      final res = await api
          .checkOTPResetPassword(
            email: email,
            otp: otp,
          )
          .load();
      if (res.status) {
        Get.off(() => ResetForgotPasswordPage(email, otp));
      } else {
        CMessageDialog.show(message: res.message);
      }
    } else {
      CMessageDialog.show(
        message: "Veuillez saisir le code OTP reçu par e-mail.",
      );
    }
  }
}
