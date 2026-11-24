import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DataResponse<T> {
  bool status = false;
  T? data;
  String message = "Désolé, une erreur est survenue. Veuillez réessayer SVP.";
  String detailErrors = "";

  /// Code HTTP de la réponse du serveur, quand il y en a une (permet de
  /// distinguer par exemple un solde insuffisant, 402, d'une panne).
  int? statusCode;

  DataResponse.success({required this.data, this.message = ""}) : status = true;

  DataResponse.error(
      {this.message =
          "Désolé, une erreur est survenue. Veuillez réessayer SVP.",
      this.detailErrors = "",
      this.statusCode,
      dynamic systemError,
      dynamic stackTrace}) {
    if (kDebugMode && systemError != null) {
      Sentry.captureException(systemError, stackTrace: stackTrace);
      print(systemError);
      print(stackTrace);
    }
  }
}
