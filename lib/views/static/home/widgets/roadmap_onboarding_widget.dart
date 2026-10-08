import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/boutiques/edition_boutique_page.dart';
import 'package:ateliya/views/static/home/widgets/build_section_card.dart';
import 'package:ateliya/views/static/home/widgets/road_map_step.dart';
import 'package:ateliya/views/static/modele/modele_list_page.dart';
import 'package:ateliya/views/static/modele_boutique/modele_list_boutique_page.dart';
import 'package:ateliya/views/static/ateliers/edition_atelier_page.dart';
import 'package:ateliya/views/static/type_mesure/type_mesure_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RoadmapOnboardingWidget extends StatelessWidget {
  final HomePageVctl ctl;
  const RoadmapOnboardingWidget(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        // Bannière d'accueil : un bloc de couleur franche plutôt qu'une
        // icône pâle sur fond blanc, pour que l'écran ait un peu d'éclat
        // dès le premier regard.
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.fromLTRB(22, 24, 18, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Bienvenue sur Ateliya !",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      "Configurez votre espace de travail en choisissant le type de structure qui vous correspond.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(14),
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.14),
                ),
                child: SvgPicture.asset(
                  "assets/images/svg/atelier.svg",
                  height: 30,
                  width: 30,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
        BuildSectionCard(
          title: "Configuration Boutique",
          icon: Icons.storefront_rounded,
          color: AppColors.primary,
          steps: [
            RoadmapStep(
              number: "1",
              title: "Créer une boutique",
              description: "Définissez votre point de vente principal.",
              enabled: !ctl.user.hasBoutique,
              done: ctl.user.hasBoutique,
              onTap: () async {
                final res = await Get.to(() => const EditionBoutiquePage());
                if (res != null) {
                  ctl.user.hasBoutique = true;
                  ctl.update();
                }
              },
            ),
            RoadmapStep(
              number: "2",
              title: "Création des modèles",
              description: "Ajoutez vos modèles de base (ex: Robe, Tunique).",
              onTap: () => Get.to(() => const ModeleListPage()),
              enabled: ctl.user.hasBoutique,
            ),
            RoadmapStep(
              number: "3",
              title: "Création des modèles boutique",
              description:
                  "Définissez les modèles associés à votre boutique avec leurs tarifs.",
              onTap: () => Get.to(() => const ModeleListBoutiquePage()),
              enabled: ctl.user.hasBoutique,
            ),
          ],
        ),
        const Gap(20),
        const Row(
          children: [
            Expanded(
              child: Divider(color: AppColors.fieldBorder, thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OU",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: AppColors.fieldBorder, thickness: 1),
            ),
          ],
        ),
        const Gap(20),
        BuildSectionCard(
          title: "Configuration de l'Atelier",
          icon: Icons.precision_manufacturing_rounded,
          color: AppColors.secondary,
          steps: [
            RoadmapStep(
              number: "1",
              title: "Créer un atelier",
              description: "Ajoutez votre atelier de production.",
              enabled: !ctl.user.hasSuccursale,
              done: ctl.user.hasSuccursale,
              onTap: () async {
                final res = await Get.to(() => const EditionAtelierPage());
                if (res != null) {
                  ctl.user.hasSuccursale = true;
                  ctl.update();
                }
              },
            ),
            RoadmapStep(
              number: "2",
              title: "Types et catégories de mesures",
              description:
                  "Ajoutez des mensurations par type (ex: carrure, épaule pour Robe).",
              onTap: () => Get.to(() => const TypeMesureListPage()),
              enabled: ctl.user.hasSuccursale,
            ),
          ],
        ),
      ],
    );
  }
}
