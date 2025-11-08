import 'package:app_couture/tools/constants/env.dart';
import 'package:app_couture/tools/services/notification_service.dart';
import 'package:app_couture/tools/widgets/themes/app_theme.dart';
import 'package:app_couture/views/static/starting/splash_screen_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        );
    await NotificationService.setup();
  } catch (e) {
    if (kDebugMode) print("Error initializing notifications: $e");
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDNS;
      options.sendDefaultPii = true;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
      options.replay.sessionSampleRate = 0.5;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () => runApp(
      GetMaterialApp(
        title: Env.appName,
        theme: AppTheme.light,
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreenPage(),
      ),
    ),
  );
}
