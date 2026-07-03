import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/home_windows_vctl.dart';
import 'package:ateliya/views/static/home/widgets/build_tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class HomeWindows extends StatelessWidget {
  const HomeWindows({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeWindowsVctl(),
      builder: (ctl) {
        return Obx(() {
          final entite = ctl.getEntite().value;
          final isBoutique = entite is Boutique;
          return Scaffold(
            backgroundColor: Colors.white,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity:
                      CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(ctl.page),
                child: ctl.pages[ctl.page],
              ),
            ),
            floatingActionButton: isBoutique
                ? FloatingActionButton(
                    heroTag: "boutique",
                    backgroundColor: AppColors.primary,
                    elevation: 6,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: ctl.page == 4
                            ? AppColors.yellow
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    onPressed: () {
                      ctl.page = 4;
                      ctl.update();
                    },
                    child: AnimatedScale(
                      scale: ctl.page == 4 ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: SvgPicture.asset(
                        "assets/images/svg/store.svg",
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          ctl.page == 4 ? AppColors.yellow : Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                isBoutique ? FloatingActionButtonLocation.centerDocked : null,
            bottomNavigationBar: BottomAppBar(
              padding: EdgeInsets.zero,
              shape: isBoutique ? const CircularNotchedRectangle() : null,
              notchMargin: 8,
              color: Colors.white,
              elevation: 16,
              shadowColor: Colors.black.withOpacity(0.15),
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BuildTabItem(
                        ctl: ctl,
                        index: 0,
                        icon: IcoFontIcons.uiHome,
                        label: "Accueil"),
                    BuildTabItem(
                        ctl: ctl,
                        index: 1,
                        icon: FontAwesomeIcons.gauge,
                        label: "Stats"),
                    if (isBoutique) const SizedBox(width: 48),
                    BuildTabItem(
                        ctl: ctl,
                        index: 2,
                        icon: IcoFontIcons.list,
                        label: "Activités"),
                    BuildTabItem(
                        ctl: ctl,
                        index: 3,
                        icon: IcoFontIcons.uiSettings,
                        label: "Options"),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
