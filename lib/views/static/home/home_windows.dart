import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/views/controllers/home/home_windows_vctl.dart';
import 'package:app_couture/views/static/home/home_page.dart';
import 'package:app_couture/views/static/home/sub_pages/boutique_page.dart';
import 'package:app_couture/views/static/home/sub_pages/setting_page.dart';
import 'package:app_couture/views/static/home/sub_pages/statistique_page.dart';
import 'package:app_couture/views/static/home/sub_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeWindows extends StatelessWidget {
  const HomeWindows({super.key});

  final pages = const [
    HomePage(),
    StatistiquePage(),
    BoutiquePage(),
    TransactionPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeWindowsVctl(),
      builder: (ctl) {
        return Scaffold(
          body: pages[ctl.page],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ctl.page,
            onTap: (i) {
              ctl.page = i;
              ctl.update();
            },
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/home.svg",
                  width: 30,
                ),
                label: "Accueil",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/stats.svg",
                  width: 30,
                ),
                label: "Statistiques",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/store.svg",
                  width: 30,
                ),
                label: "Boutiques",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/depenses.svg",
                  width: 30,
                ),
                label: "Transactions",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/setting.svg",
                  width: 30,
                ),
                label: "Paramètres",
              ),
            ],
          ),
        );
      },
    );
  }
}
