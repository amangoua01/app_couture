import 'package:app_couture/data/models/abstract/model.dart';
import 'package:http/http.dart' as http;

abstract class ModelFormData<T> extends Model<T> {
  ModelFormData({super.id});

  Map<String, String> toFields();

  Future<List<http.MultipartFile>> toMultipartFile();
}
