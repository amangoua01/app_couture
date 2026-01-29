import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
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
            body: pages[ctl.page],
            floatingActionButton: PlaceholderBuilder(
              condition: ctl.getEntite().value is Boutique,
              builder: () {
                return FloatingActionButton(
                  heroTag: "boutique",
                  onPressed: () {
                    if (ctl.getEntite() is Boutique) {
                      ctl.page = 4;
                      ctl.update();
                    }
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
                );
              },
            ),
            floatingActionButtonLocation: ternaryFn(
              condition: ctl.getEntite().value is Boutique,
              ifTrue: FloatingActionButtonLocation.centerDocked,
              ifFalse: FloatingActionButtonLocation.endFloat,
            ),
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
              gapLocation: ternaryFn(
                condition: ctl.getEntite().value is Boutique,
                ifTrue: GapLocation.center,
                ifFalse: GapLocation.none,
              ),
              notchSmoothness: NotchSmoothness.softEdge,
              onTap: (index) {
                ctl.page = index;
                ctl.update();
              },
              //other params
            ),
          );
        });
      },
    );
  }
}
