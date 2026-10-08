import 'package:ateliya/tools/models/netword_config.dart';

/// Réglages qui changent d'un environnement à l'autre.
///
/// L'adresse du serveur et la clé Gemini sont déclarées ensemble : ce sont les
/// deux accès extérieurs de l'application, et les garder au même endroit évite
/// d'en changer un en oubliant l'autre au moment de passer en production.
enum AppEnv {
  dev(
    networdConfig: NetwordConfig(
      host: "backend.ateliya.com",
      scheme: "https",
    ),
    geminiApiKey: "AQ.Ab8RN6IXoCkvRHVQxMF1WmjSc3PkvgW739nn1yeVrUhfN_JByg",
  ),
  prod(
    networdConfig: NetwordConfig(
      host: "backendprod.ateliya.com",
      scheme: "https",
    ),
    geminiApiKey: "AQ.Ab8RN6IXoCkvRHVQxMF1WmjSc3PkvgW739nn1yeVrUhfN_JByg",
  );

  final NetwordConfig networdConfig;

  /// Clé de l'API Gemini utilisée par les assistants de dictée.
  final String geminiApiKey;

  const AppEnv({required this.networdConfig, required this.geminiApiKey});
}
