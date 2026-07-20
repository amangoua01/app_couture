import 'dart:io';

import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_slide.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MallCouverturesVctl extends AuthViewController {
  final _api = MallApi();

  List<MallSlide> slides = [];
  bool loading = true;

  // Form controllers
  final titleCtl = TextEditingController();
  final subtitleCtl = TextEditingController();
  final descriptionCtl = TextEditingController();
  final badgeCtl = TextEditingController();
  final priceCtl = TextEditingController();

  File? imageFile;
  String? existingImageUrl;

  void setImage(File f) {
    imageFile = f;
    update();
  }

  void removeImage() {
    imageFile = null;
    existingImageUrl = null;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadSlides();
  }

  @override
  void onClose() {
    titleCtl.dispose();
    subtitleCtl.dispose();
    descriptionCtl.dispose();
    badgeCtl.dispose();
    priceCtl.dispose();
    super.onClose();
  }

  Future<void> loadSlides() async {
    loading = true;
    update();
    final res = await _api.getSlides().load();
    if (res.status) slides = res.data!;
    loading = false;
    update();
  }

  void clearForm() {
    titleCtl.clear();
    subtitleCtl.clear();
    descriptionCtl.clear();
    badgeCtl.clear();
    priceCtl.clear();
    imageFile = null;
    existingImageUrl = null;
  }

  void fillForm(MallSlide slide) {
    titleCtl.text = slide.title;
    subtitleCtl.text = slide.subtitle ?? '';
    descriptionCtl.text = slide.description ?? '';
    badgeCtl.text = slide.badgeText ?? '';
    priceCtl.text = slide.price?.toString() ?? '';
    imageFile = null;
    existingImageUrl = slide.image?.fullUrl;
    update();
  }

  Map<String, dynamic> _buildBody() => {
        'title': titleCtl.text,
        'subtitle': subtitleCtl.text,
        'description': descriptionCtl.text,
        'badgeText': badgeCtl.text,
        if (priceCtl.text.isNotEmpty) 'price': int.tryParse(priceCtl.text),
      };

  Future<void> createSlide() async {
    final res = await _api.createSlide(_buildBody(), image: imageFile).load();
    if (res.status) {
      CSnackbar.show(message: 'Slide créé avec succès', isSuccess: true);
      clearForm();
      await loadSlides();
    } else {
      CSnackbar.show(message: res.message);
    }
  }

  Future<void> updateSlide(int id) async {
    final res =
        await _api.updateSlide(id, _buildBody(), image: imageFile).load();
    if (res.status) {
      CSnackbar.show(message: 'Slide modifié avec succès', isSuccess: true);
      clearForm();
      await loadSlides();
      Get.back(result: 'updated');
    } else {
      CSnackbar.show(message: res.message);
    }
  }

  Future<void> deleteSlide(int id) async {
    final res = await _api.deleteSlide(id).load();
    if (res.status) {
      CSnackbar.show(message: 'Slide supprimé', isSuccess: true);
      await loadSlides();
    } else {
      CSnackbar.show(message: res.message);
    }
  }
}
