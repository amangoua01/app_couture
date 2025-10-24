import 'package:app_couture/api/auth_api.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/views/static/auth/auth_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetForgotPasswordPageVctl extends GetxController {
  final newPasswordCtl = TextEditingController();
  final confirmPasswordCtl = TextEditingController();
  final String email;
  final String otp;
  final api = AuthApi();
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
        Get.offAll(() => const AuthHomePage());
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }
}
