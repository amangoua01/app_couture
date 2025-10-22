import 'package:app_couture/tools/components/custom_http_client.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/tools/constants/env.dart';
import 'package:app_couture/tools/extensions/types/map.dart';
import 'package:app_couture/tools/extensions/types/string.dart';

abstract class WebController {
  String get module;

  final client = CustomHttpClient();

  Uri urlBuilder({String? api, Json? params}) {
    if (api.value.startsWith("/")) api = api.value.substring(1);
    // var url = "${Env.baseUrl}/$module${api != null ? "/$api" : ""}";

    return Env.baseUrl.build(module: module, api: api, params: params);
  }

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  Map<String, String> get authHeaders => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${SessionManagerViewController.jwt}",
      };
}
