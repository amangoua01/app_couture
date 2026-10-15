import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/seasonal_logo.dart';
import 'package:ateliya/views/controllers/starting/splash_screen_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashScreenPageVctl(),
      builder: (ctl) {
        // Même fond et même carte que l'écran natif qui précède : la
        // transition est invisible, la fête du jour apparaît juste après.
        return Scaffold(
          backgroundColor:
              MediaQuery.platformBrightnessOf(context) == Brightness.dark
                  ? const Color(0xFF062720)
                  : AppColors.primary,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Centrée sur l'écran entier, comme l'image native.
                SeasonalLogoFrame(
                  size: 172,
                  child: Image.asset(
                    "assets/images/logo_ateliya.png",
                    height: 106,
                    fit: BoxFit.contain,
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      "Ateliya © 2025",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
