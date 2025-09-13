import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  static final picker = ImagePicker();
  static Future<File?> pickImage({
    ImageSource from = ImageSource.camera,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    double? maxWidth,
    double? maxHeight,
  }) async {
    final pickedFile = await picker.pickImage(
      source: from,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return (pickedFile != null) ? File(pickedFile.path) : null;
  }

  static Future<List<File>> pickMultipleImages({
    int? imageQuality,
  }) async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: imageQuality);
    if (pickedFiles.isEmpty) {
      return [];
    } else {
      return pickedFiles.map((e) => File(e.path)).toList();
    }
  }
}
