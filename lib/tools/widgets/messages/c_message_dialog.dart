import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart' show EasyLoading;

abstract class CMessageDialog {
  static Future<void> show({
    required String? message,
    bool isSuccess = false,
  }) {
    if (isSuccess) {
      return EasyLoading.showSuccess(message.value);
    } else {
      return EasyLoading.showError(message.value);
    }
  }

  // Get.defaultDialog(
  //   textConfirm: "OK",
  //   buttonColor: primaryColor,
  //   confirmTextColor: Colors.white,
  //   title: title ?? "Message",
  //   titleStyle: titleStyle,
  //   confirm: confirm,
  //   content: Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: Text(
  //       message ?? "Erreur",
  //       textAlign: TextAlign.center,
  //     ),
  //   ),
  //   radius: radius,
  //   actions: actions,
  //   onConfirm: () => Get.back(),
  //   barrierDismissible: barrierDismissible,
  // );
}
