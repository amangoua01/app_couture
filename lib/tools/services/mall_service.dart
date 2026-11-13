import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tout ce qui concerne la vitrine en ligne de l'entreprise (Mall Ya) :
/// son adresse, son partage, et le « réveil » du site avant qu'on l'ouvre.
abstract class MallService {
  static const _host = 'malliya.ateliya.com';

  static Uri urlOf(String code) => Uri.https(_host, '/enterprise/$code');

  static DateTime? _lastWarmUp;

  /// Réveille le site en tâche de fond. Hébergé sur une machine qui met
  /// l'application en veille quand personne ne la visite, le site peut
  /// mettre une vingtaine de secondes à répondre au premier visiteur : on
  /// envoie donc une requête dès que l'utilisateur voit le lien (Options,
  /// accueil), pour que le site soit prêt quand il appuie dessus.
  /// Au plus une fois toutes les quatre minutes ; les erreurs sont ignorées.
  static void warmUp(String? code) {
    if (code == null || code.isEmpty) return;
    final now = DateTime.now();
    if (_lastWarmUp != null &&
        now.difference(_lastWarmUp!) < const Duration(minutes: 4)) {
      return;
    }
    _lastWarmUp = now;
    unawaited(_ping(urlOf(code)));
  }

  static Future<void> _ping(Uri url) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 30);
    try {
      final request = await client.getUrl(url);
      final response = await request.close().timeout(const Duration(seconds: 45));
      await response.drain<void>();
    } catch (_) {
      // Simple réveil : rien à signaler à l'utilisateur.
    } finally {
      client.close(force: true);
    }
  }

  static Future<void> share(String code) => Share.share(
        'Découvrez notre boutique sur Mall Ya :\n${urlOf(code)}',
      );

  static Future<void> copyLink(String code) =>
      Clipboard.setData(ClipboardData(text: urlOf(code).toString()));

  static Future<bool> openInBrowser(String code) =>
      launchUrl(urlOf(code), mode: LaunchMode.externalApplication);
}
