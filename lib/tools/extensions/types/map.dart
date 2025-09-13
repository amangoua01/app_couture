import 'dart:convert';

typedef Json = Map<String, dynamic>;

extension MapExt on Map? {
  String parseToJson() {
    if (this != null) {
      return json.encode(this!);
    }
    return "";
  }
}
