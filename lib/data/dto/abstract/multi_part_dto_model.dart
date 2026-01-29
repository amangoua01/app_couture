import 'package:ateliya/data/dto/upload_file_dto.dart';

abstract class MultiPartDtoModel {
  const MultiPartDtoModel();

  Map<String, String> toJson();

  List<UploadFileDto> getFiles();
}
