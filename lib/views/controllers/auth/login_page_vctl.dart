import 'package:app_couture/api/auth_api.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/views/static/home/home_windows.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageVctl extends SessionManagerViewController {
  final loginCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final api = AuthApi();
  bool passwordHide = true;
  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      final res = await api
          .login(login: loginCtl.text, password: passwordCtl.text)
          .load();
      if (res.status) {
        user = res.data!;
        Get.offAll(() => const HomeWindows());
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }
}
