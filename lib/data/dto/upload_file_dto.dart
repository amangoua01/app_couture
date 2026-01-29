import 'dart:io';

class UploadFileDto {
  final String fieldName;
  final File file;

  UploadFileDto({required this.fieldName, required this.file});
}
