import 'package:ateliya/tools/constants/env.dart';
import 'package:ateliya/tools/services/notification_service.dart';
import 'package:ateliya/tools/widgets/themes/app_theme.dart';
import 'package:ateliya/views/static/starting/splash_screen_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  try {
    SentryWidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Or adjust based on theme
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

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
        locale: const Locale("fr", "FR"),
        fallbackLocale: const Locale('en', 'US'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
        ],
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreenPage(),
      ),
    ),
  );
}
