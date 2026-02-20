import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/views/controllers/home/home_windows_vctl.dart';
import 'package:ateliya/views/static/home/home_page.dart';
import 'package:ateliya/views/static/home/sub_pages/boutique_page.dart';
import 'package:ateliya/views/static/home/sub_pages/setting_page.dart';
import 'package:ateliya/views/static/home/sub_pages/statistique_page.dart';
import 'package:ateliya/views/static/home/sub_pages/transaction_page.dart';
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
        return Obx(() {
          return Scaffold(
            backgroundColor:
                Colors.grey[50], // Light background for the app content
            body: pages[ctl.page],
            floatingActionButton: ctl.getEntite().value is Boutique
                ? FloatingActionButton(
                    heroTag: "boutique",
                    backgroundColor: AppColors.primary,
                    elevation: 4,
                    shape: const CircleBorder(),
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
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              backgroundColor: Colors.white,
              icons: const [
                IcoFontIcons.uiHome,
                FontAwesomeIcons.gauge,
                IcoFontIcons.list,
                IcoFontIcons.uiSettings,
              ],
              iconSize: 26,
              inactiveColor: Colors.grey[400],
              activeIndex: ctl.page,
              activeColor: AppColors.primary,
              gapLocation: ctl.getEntite().value is Boutique
                  ? GapLocation.center
                  : GapLocation.none,
              notchSmoothness: NotchSmoothness.softEdge,
              leftCornerRadius: 20,
              rightCornerRadius: 20,
              shadow: BoxShadow(
                offset: const Offset(0, -4),
                blurRadius: 12,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.05),
              ),
              safeAreaValues: const SafeAreaValues(bottom: true),
              onTap: (index) {
                ctl.page = index;
                ctl.update();
              },
            ),
          );
        });
      },
    );
  }
}
