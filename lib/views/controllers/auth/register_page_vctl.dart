import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/api/pays_api.dart';
import 'package:ateliya/data/dto/user_register_dto.dart';
import 'package:ateliya/data/models/pays.dart';
import 'package:ateliya/tools/components/session_manager_view_controller.dart';
import 'package:ateliya/tools/constants/env.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/static/home/home_windows.dart';
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
  bool showPassword = false;
  bool showConfirmPassword = false;

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
          device: Env.deviceType,
        );
        final res = await api.register(data).load();
        if (res.status) {
          user = res.data!;
          Get.to(() => const HomeWindows());
        } else {
          CMessageDialog.show(message: res.message);
        }
      }
    }
  }
}
