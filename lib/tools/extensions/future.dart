import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

extension FutureExtension<T> on Future<T> {
  Future<T> load({
    String? status,
    SpinKitWaveSpinner? indicator,
  }) async {
    // 🔹 Configuration du EasyLoading (transparent + sans fond noir)
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.transparent
      // ignore: deprecated_member_use
      ..maskColor = Colors.black.withOpacity(0.8)
      ..boxShadow = []
      ..indicatorColor = AppColors.primary
      ..textColor = Colors.white
      ..userInteractions = false
      ..dismissOnTap = false
      ..contentPadding = EdgeInsets.zero
      ..radius = 0;

    // 🔹 Affiche le loader
    await EasyLoading.show(
      indicator: indicator ??
          const SpinKitWaveSpinner(
            size: 60,
            trackColor: Colors.white,
            color: AppColors.secondary,
            waveColor: AppColors.secondary,
            duration: Duration(seconds: 1),
          ),
      maskType: EasyLoadingMaskType.custom,
      status: status ?? 'Chargement...',
    );

    try {
      // 🔹 Exécute le Future d'origine
      var result = await this;
      return result;
    } finally {
      // 🔹 Ferme le loader, qu’il y ait succès ou erreur
      await EasyLoading.dismiss();
    }
  }
}
