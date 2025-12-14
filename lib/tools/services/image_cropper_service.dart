import 'dart:io';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

abstract class ImageCropperService {
  static final _croppedFile = ImageCropper();
  static Future<File?> crop(File image) async {
    var file = await _croppedFile.cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Redimension',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.black,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'Redimension',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
    if (file == null) return null;
    return File(file.path);
  }
}
