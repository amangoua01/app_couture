import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/static/auth/forgot_password/forgot_pass_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPageVctl extends GetxController {
  final emailCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final api = AuthApi();

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      final res = await api.initResetPassword(emailCtl.text.trim()).load();
      if (res.status) {
        Get.off(() => ForgotPassOtpPage(emailCtl.text.trim()));
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }
}
