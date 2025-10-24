import 'dart:io';

import 'package:app_couture/tools/constants/app_env.dart';
import 'package:app_couture/tools/models/currency.dart';
import 'package:app_couture/tools/models/netword_config.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Env {
  static const String appName = 'Moomen Pro';
  static const String appVersion = '1.0.31';
  static const int buildVersion = 32;
  static final fontFamily = GoogleFonts.poppins().fontFamily;

  static const defaultDevise = Currency("Fcfa", code: "XOF", decimalDigits: 0);

  static const AppEnv env = AppEnv.dev;

  static const _hostDev = NetwordConfig(
    host: "backend.ateliya.com",
  );
  static const _hostProd = NetwordConfig(
    host: "backend.ateliya.com",
    scheme: "https",
  );

  static NetwordConfig get baseUrl =>
      (env == AppEnv.dev) ? _hostDev : _hostProd;

  static const nbItemInListPage = 10;
  static const supportMail = "supports@moomen.pro";
  static const supportTel = "+2250500262848";
  static const supportWhatsApp = "+2250500262848";

  static const termsAndConditionsUrl = "https://moomen.pro/terms-conditions";

  static String playStoreUrl =
      "https://play.google.com/store/apps/details?id=pro.moomen.app&pcampaignid=web_share";
  static String appStoreUrl =
      "https://apps.apple.com/fr/app/moomen-pro/id6744434813";

  static String get copyRight =>
      "© ${DateTime.now().year} $appName. v. $appVersion";
  static String get deviceType => Platform.operatingSystem;

  static String fullImageUrl(String path) =>
      "${baseUrl.url}/${path.replaceFirst("/", "")}";
  static const sentryDNS =
      'https://e8b5af4fb73d1690ad8dec93a4434db5@o4510011872051200.ingest.de.sentry.io/4510011873689680';
}
