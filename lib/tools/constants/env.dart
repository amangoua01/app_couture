import 'dart:io';

import 'package:ateliya/tools/constants/app_env.dart';
import 'package:ateliya/tools/models/currency.dart';
import 'package:ateliya/tools/models/netword_config.dart';
import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Env {
  static const String appName = 'Ateliya';
  static const String appVersion = '1.0.7';
  static const int buildVersion = 14;
  static final fontFamily = GoogleFonts.poppins().fontFamily;

  static const defaultDevise = Currency("Fcfa", code: "XOF", decimalDigits: 0);

  static const AppEnv env = AppEnv.dev;

  static NetwordConfig get baseUrl => env.networdConfig;

  static const nbItemInListPage = 10;
  static const supportMail = "supports@moomen.pro";
  static const supportTel = "+2250501242929";
  static const supportWhatsApp = "+2250501242929";

  static const termsAndConditionsUrl = "https://ateliya.com/conditions/";

  static String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.ateliya.app";
  static String appStoreUrl = "";

  static String get copyRight =>
      "© ${DateTime.now().year} $appName. v. $appVersion";
  static String get deviceType => Platform.operatingSystem;

  static String fullImageUrl(String path) => "${baseUrl.url}/uploads/$path";
  static const sentryDNS =
      'https://e8b5af4fb73d1690ad8dec93a4434db5@o4510011872051200.ingest.de.sentry.io/4510011873689680';

  static final versionChecker = InStoreAppVersionChecker(
    appId: 'com.ateliya.app',
    androidStore: AndroidStore.googlePlayStore,
    currentVersion: Env.appVersion,
  );
}
