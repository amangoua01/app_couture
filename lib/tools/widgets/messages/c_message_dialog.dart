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
}
