import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/static/starting/splash_screen_page.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;

  static void init() {
    // Handle link when app is in background or foreground
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (kDebugMode) print('DeepLink received: $uri');
      _handleDeepLink(uri);
    }, onError: (err) {
      if (kDebugMode) print('DeepLink error: $err');
    });

    // Handle link when app is terminated
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        if (kDebugMode) print('Initial DeepLink: $uri');
        _handleDeepLink(uri);
      }
    });
  }

  static void _handleDeepLink(Uri uri) {
    // Check if it's the return URL from payment
    // http://redirectionurl.ateliya.com/
    if (uri.host == 'redirectionurl.ateliya.com' ||
        uri.path == '/confirmation') {
      _processPaymentReturn(uri);
    }
  }

  static void _processPaymentReturn(Uri uri) async {
    // Show success message and refresh
    await CMessageDialog.show(
      message:
          "Paiement effectué avec succès ! Votre abonnement est en cours d'activation.",
      // onClose: () {
      //   // Rediriger vers la liste des abonnements ou l'accueil et rafraîchir
      //   Get.offAllNamed('/'); // Retour à l'accueil
      // },
    );
    Get.offAll(() => const SplashScreenPage());
  }

  static void dispose() {
    _linkSubscription?.cancel();
  }
}
