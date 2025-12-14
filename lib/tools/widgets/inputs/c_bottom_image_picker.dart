import 'dart:io';

import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/services/image_cropper_service.dart';
import 'package:ateliya/tools/services/image_picker_service.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/preview_image_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:image_picker/image_picker.dart';

abstract class CBottomImagePicker {
  static Future<File?> show({
    String? image,
    int? imageQuality,
    bool cropImage = false,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    return CBottomSheet.show(
      height: image != null ? 300 : 250,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 10),
        children: [
          Visibility(
            visible: image != null,
            child: ListTile(
              leading: const Icon(IcoFontIcons.fileImage),
              title: const Text("Afficher l'image"),
              onTap: () => Get.to(() => PreviewImagePage(image.value)),
            ),
          ),
          ListTile(
            leading: const Icon(IcoFontIcons.camera),
            subtitle: const Text("Prendre une photo depuis la caméra"), //
            title: const Text("Ouvrir la caméra"),
            onTap: () async {
              var res = await ImagePickerService.pickImage(
                imageQuality: imageQuality,
                preferredCameraDevice: preferredCameraDevice,
              );
              if (res != null) {
                if (cropImage) {
                  res = await ImageCropperService.crop(res);
                }
                Get.back(result: res);
              }
            },
          ),
          ListTile(
            leading: const Icon(IcoFontIcons.image),
            subtitle: const Text("Prendre une photo depuis la galerie"),
            title: const Text("Ouvrir la galerie"),
            onTap: () async {
              var res = await ImagePickerService.pickImage(
                from: ImageSource.gallery,
                imageQuality: imageQuality,
                preferredCameraDevice: preferredCameraDevice,
              );

              if (res != null) {
                if (cropImage) {
                  res = await ImageCropperService.crop(res);
                }
                Get.back(result: res);
              }
            },
          ),
        ],
      ),
    );
  }
}
