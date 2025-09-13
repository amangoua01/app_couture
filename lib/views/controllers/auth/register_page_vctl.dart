import 'package:app_couture/views/static/home/home_windows.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterPageVctl extends GetxController {
  final pageCtl = PageController();
  int currentPage = 0;

  void onNext() {
    if (currentPage < 1) {
      currentPage++;
      pageCtl.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    } else {
      submit();
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
    Get.to(() => const HomeWindows());
  }
}
