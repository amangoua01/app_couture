import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class EditionViewController<M extends Model,
    P extends CrudWebController> extends AuthViewController {
  final M? item;
  final P api;
  final formKey = GlobalKey<FormState>();

  EditionViewController(this.item, {required this.api});

  Future<M?> onCreate();
  Future<M?> onUpdate(M item);

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      M? res;
      if (item?.id == null) {
        res = await onCreate();
      } else {
        res = await onUpdate(item as M);
      }
      if (res != null) {
        Get.back(result: res);
      }
    }
  }

  void onInitForm(M item);

  @override
  void onInit() {
    super.onInit();
    if (item != null) {
      onInitForm(item as M);
    }
  }
}
