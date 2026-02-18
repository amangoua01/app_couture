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
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        "assets/images/logo_ateliya.png",
                        width: 100,
                      ),
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      "Ateliya © 2025",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
