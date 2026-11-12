import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/tools/constants/type_user_enum.dart';
import 'package:ateliya/tools/widgets/animations/fondu_indexed_stack.dart';
import 'package:ateliya/views/controllers/home/home_windows_vctl.dart';
import 'package:ateliya/views/static/home/widgets/floating_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  ElementNavigation(
                    icone: AppIcons.house,
                    iconeActive: AppIconsFill.house,
                    libelle: "Accueil",
                  ),
                  ElementNavigation(
                    icone: AppIcons.gearSix,
                    iconeActive: AppIconsFill.gearSix,
                    libelle: "Options",
                  ),
                ]
              : [
                  const ElementNavigation(
                    icone: AppIcons.house,
                    iconeActive: AppIconsFill.house,
                    libelle: "Accueil",
                  ),
                  const ElementNavigation(
                    icone: AppIcons.chartLineUp,
                    iconeActive: AppIconsBold.chartLineUp,
                    libelle: "Stats",
                  ),
                  if (isBoutique)
                    const ElementNavigation(
                      icone: AppIcons.storefront,
                      iconeActive: AppIconsFill.storefront,
                      libelle: "Boutique",
                    ),
                  const ElementNavigation(
                    icone: AppIcons.listChecks,
                    iconeActive: AppIconsBold.listChecks,
                    libelle: "Activités",
                  ),
                  const ElementNavigation(
                    icone: AppIcons.gearSix,
                    iconeActive: AppIconsFill.gearSix,
                    libelle: "Options",
                  ),
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
