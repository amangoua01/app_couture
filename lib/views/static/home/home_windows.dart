import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/extensions/ternary_fn.dart';
import 'package:app_couture/views/controllers/home/home_windows_vctl.dart';
import 'package:app_couture/views/static/home/home_page.dart';
import 'package:app_couture/views/static/home/sub_pages/boutique_page.dart';
import 'package:app_couture/views/static/home/sub_pages/setting_page.dart';
import 'package:app_couture/views/static/home/sub_pages/statistique_page.dart';
import 'package:app_couture/views/static/home/sub_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class HomeWindows extends StatelessWidget {
  const HomeWindows({super.key});

  final pages = const [
    HomePage(),
    StatistiquePage(),
    TransactionPage(),
    SettingPage(),
    BoutiquePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeWindowsVctl(),
      builder: (ctl) {
        return Scaffold(
          body: pages[ctl.page],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ctl.page = 4;
              ctl.update();
            },
            child: SvgPicture.asset(
              "assets/images/svg/store.svg",
              width: 25,
              colorFilter: ColorFilter.mode(
                ternaryFn(
                  condition: ctl.page == 4,
                  ifTrue: AppColors.yellow,
                  ifFalse: Colors.white,
                ),
                BlendMode.srcIn,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: AppColors.primary,
            icons: const [
              IcoFontIcons.uiHome,
              FontAwesomeIcons.gauge,
              IcoFontIcons.list,
              IcoFontIcons.uiSettings,
            ],
            iconSize: 30,
            inactiveColor: Colors.white,
            activeIndex: ctl.page,
            activeColor: AppColors.yellow,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,

            onTap: (index) {
              ctl.page = index;
              ctl.update();
            },
            //other params
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   type: BottomNavigationBarType.fixed,
          //   currentIndex: ctl.page,
          //   onTap: (i) {
          //     ctl.page = i;
          //     ctl.update();
          //   },
          //   selectedItemColor: AppColors.primary,
          //   unselectedItemColor: Colors.grey,
          //   selectedLabelStyle: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: AppColors.primary,
          //   ),
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/images/svg/home.svg",
          //         width: 25,
          //       ),
          //       label: "Accueil",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/images/svg/stats.svg",
          //         width: 25,
          //       ),
          //       label: "Statistiques",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/images/svg/store.svg",
          //         width: 25,
          //       ),
          //       label: "Boutiques",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/images/svg/depenses.svg",
          //         width: 25,
          //       ),
          //       label: "Transactions",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/images/svg/setting.svg",
          //         width: 25,
          //       ),
          //       label: "Paramètres",
          //     ),
          //   ],
          // ),
        );
      },
    );
  }
}
