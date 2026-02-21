import 'package:ateliya/tools/models/netword_config.dart';

enum AppEnv {
  dev(
    networdConfig: NetwordConfig(
      host: "backend.ateliya.com",
      scheme: "https",
    ),
  ),
  prod(
    networdConfig: NetwordConfig(
      host: "backendprod.ateliya.com",
      scheme: "https",
    ),
  );

  final NetwordConfig networdConfig;

  const AppEnv({required this.networdConfig});
}
