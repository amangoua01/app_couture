import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/type_user_enum.dart';
import 'package:ateliya/tools/widgets/animations/fondu_indexed_stack.dart';
import 'package:ateliya/views/controllers/home/home_windows_vctl.dart';
import 'package:ateliya/views/static/home/widgets/floating_nav_bar.dart';
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
          final isAc = ctl.user.type?.code == TypeUserEnum.ac.code;

          final indices = isAc
              ? const [0, 3]
              : isBoutique
                  ? const [0, 1, 4, 2, 3]
                  : const [0, 1, 2, 3];

          final elements = isAc
              ? const [
                  ElementNavigation(icone: IcoFontIcons.uiHome, libelle: "Accueil"),
                  ElementNavigation(icone: IcoFontIcons.uiSettings, libelle: "Options"),
                ]
              : [
                  const ElementNavigation(icone: IcoFontIcons.uiHome, libelle: "Accueil"),
                  ElementNavigation(icone: FontAwesomeIcons.gauge.data, libelle: "Stats"),
                  if (isBoutique)
                    ElementNavigation(
                      icone: Icons.storefront_rounded,
                      libelle: "Boutique",
                      icone0nglet: SvgPicture.asset(
                        "assets/images/svg/store.svg",
                        width: 22,
                        colorFilter: ColorFilter.mode(
                          ctl.page == 4 ? Colors.white : Colors.grey[400]!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  const ElementNavigation(icone: IcoFontIcons.list, libelle: "Activités"),
                  const ElementNavigation(icone: IcoFontIcons.uiSettings, libelle: "Options"),
                ];

          return Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            body: FonduIndexedStack(index: ctl.page, children: ctl.pages),
            bottomNavigationBar: FloatingNavBar(
              indexActif: indices.indexOf(ctl.page).clamp(0, indices.length - 1),
              onChange: (i) {
                ctl.page = indices[i];
                ctl.update();
              },
              elements: elements,
            ),
          );
        });
      },
    );
  }
}
