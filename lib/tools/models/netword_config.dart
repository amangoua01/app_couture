import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class NetwordConfig {
  final String host;
  final int? port;
  final String scheme;
  final String suffix;
  final Json? params;

  const NetwordConfig({
    required this.host,
    this.port,
    this.scheme = "http",
    this.suffix = "api",
    this.params,
  });

  Uri build({
    required String module,
    String? api,
    Json? params,
  }) {
    String path;
    if (module.isEmpty) {
      if (api == null) {
        path = "/";
      } else {
        if (api.value.startsWith("/")) api = api.value.substring(1);
        path = "/$api";
      }
    } else {
      if (api == null) {
        path = "/$module";
      } else {
        if (api.value.startsWith("/")) api = api.value.substring(1);
        path = "/$module/$api";
      }
    }
    if (path.endsWith("/")) path = path.substring(0, path.length - 1);

    if (params != null) {
      params.addAll(this.params ?? {});
    } else {
      params = this.params;
    }

    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: suffix + path,
      queryParameters: params,
    );
  }

  String get url {
    if (port != null) {
      return "$scheme://$host:$port";
    } else {
      return "$scheme://$host";
    }
  }
}
