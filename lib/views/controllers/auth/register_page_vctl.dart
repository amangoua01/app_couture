import 'package:app_couture/api/auth_api.dart';
import 'package:app_couture/api/pays_api.dart';
import 'package:app_couture/data/dto/user_register_dto.dart';
import 'package:app_couture/data/models/pays.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:app_couture/views/static/home/home_windows.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterPageVctl extends SessionManagerViewController {
  final pageCtl = PageController();
  int currentPage = 0;
  final paysApi = PaysApi();
  Pays? selectedPays;
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final confirmPasswordCtl = TextEditingController();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final nomEntrepriseCtl = TextEditingController();
  final telEntrepriseCtl = TextEditingController();
  final emailEntrepriseCtl = TextEditingController();
  final api = AuthApi();
  void onNext() {
    if (currentPage < 1) {
      if (formKey1.currentState!.validate()) {
        currentPage++;
        pageCtl.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        update();
      }
    } else {
      submit();
    }
  }

  Future<List<Pays>> fetchPays() async {
    final response = await paysApi.getAllPays();
    if (response.status) {
      return response.data!;
    } else {
      return [];
    }
  }

  void onPrev() {
    if (currentPage > 0) {
      currentPage--;
      pageCtl.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  Future<void> submit() async {
    if (formKey2.currentState!.validate()) {
      final rep = await CChoiceMessageDialog.show(
        title: "Confirmation",
        message: "Voulez-vous vraiment créer ce compte ?",
      );

      if (rep == true) {
        final data = UserRegisterDto(
          email: emailEntrepriseCtl.text,
          password: passwordCtl.text,
          confirmPassword: confirmPasswordCtl.text,
          denominationEntreprise: nomEntrepriseCtl.text,
          emailEntreprise: emailEntrepriseCtl.text,
          numeroEntreprise: telEntrepriseCtl.text,
          pays: selectedPays!.id!,
        );
        final res = await api.register(data).load();
        if (res.status) {
          user = res.data!;
          Get.to(() => const HomeWindows());
        } else {
          CAlertDialog.show(message: res.message);
        }
      }
    }
  }
}
