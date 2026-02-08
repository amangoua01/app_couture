import 'package:flutter_easyloading/flutter_easyloading.dart';

extension FutureExtension<T> on Future<T> {
  Future<T> load({String? status}) async {
    await EasyLoading.show(maskType: EasyLoadingMaskType.black, status: status);
    try {
      final res = await this;
      return res;
    } catch (e) {
      return this;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
