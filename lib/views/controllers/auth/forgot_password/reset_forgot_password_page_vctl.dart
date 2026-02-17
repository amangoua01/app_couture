import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/static/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetForgotPasswordPageVctl extends GetxController {
  final newPasswordCtl = TextEditingController();
  final confirmPasswordCtl = TextEditingController();
  final String email;
  final String otp;
  final api = AuthApi();
  bool passwordHide = true;
  bool confirmPasswordHide = true;
  final formKey = GlobalKey<FormState>();

  ResetForgotPasswordPageVctl(this.email, this.otp);

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      final res = await api
          .finalizeResetPassword(
            email: email,
            otp: otp,
            newPassword: newPasswordCtl.text.trim(),
          )
          .load();
      if (res.status) {
        Get.offAll(() => const LoginPage());
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }
}
