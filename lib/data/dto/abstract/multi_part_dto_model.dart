import 'package:http/http.dart';

abstract class MultiPartDtoModel {
  const MultiPartDtoModel();

  Map<String, String> toJson();

  Future<List<MultipartFile>> getFiles();
}
