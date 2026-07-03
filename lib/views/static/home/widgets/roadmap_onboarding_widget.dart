import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/boutiques/edition_boutique_page.dart';
import 'package:ateliya/views/static/home/widgets/build_section_card.dart';
import 'package:ateliya/views/static/home/widgets/road_map_step.dart';
import 'package:ateliya/views/static/modele/modele_list_page.dart';
import 'package:ateliya/views/static/modele_boutique/modele_list_boutique_page.dart';
import 'package:ateliya/views/static/surcursales/edition_surcusale_page.dart';
import 'package:ateliya/views/static/type_mesure/type_mesure_list_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RoadmapOnboardingWidget extends StatelessWidget {
  final HomePageVctl ctl;
  const RoadmapOnboardingWidget(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Bienvenue sur Ateliya !",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const Gap(10),
        const Text(
          "Pour commencer, configurez votre espace de travail en choisissant le type de structure qui vous correspond.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const Gap(20),
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
                child: Divider(color: AppColors.fieldBorder, thickness: 1)),
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
                child: Divider(color: AppColors.fieldBorder, thickness: 1)),
          ],
        ),
        const Gap(20),
        BuildSectionCard(
          title: "Configuration Succursale (Atelier)",
          icon: Icons.precision_manufacturing_rounded,
          color: AppColors.secondary,
          steps: [
            RoadmapStep(
              number: "1",
              title: "Créer une succursale",
              description: "Ajoutez votre atelier de production.",
              enabled: !ctl.user.hasSuccursale,
              onTap: () async {
                final res = await Get.to(() => const EditionSurcusalePage());
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
