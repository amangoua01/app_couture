import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Ouvre une modale sur fond flouté, avec une entrée en fondu + léger
/// rebond plutôt que le pop-in instantané de [Get.dialog]. Point unique de
/// réglage : toutes les modales de confirmation de l'app passent par ici.
abstract class AnimatedDialog {
  static Future<T?> show<T>(
    Widget child, {
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x59000000),
  }) {
    return showGeneralDialog<T>(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Fermer',
      barrierColor: barrierColor,
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (_, _, _) => child,
      transitionBuilder: (_, animation, _, child) {
        final courbe = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 6 * animation.value,
            sigmaY: 6 * animation.value,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween(begin: 0.85, end: 1.0).animate(courbe),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
