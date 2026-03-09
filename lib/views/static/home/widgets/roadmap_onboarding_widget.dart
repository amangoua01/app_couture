import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/boutiques/edition_boutique_page.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      children: [
        const Text(
          "Bienvenue sur Ateliya ! 🎉",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Gap(10),
        Text(
          "Pour commencer, vous devez configurer votre espace de travail. Choisissez le type de structure qui vous correspond.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        const Gap(30),

        // Section Boutique
        _buildSectionCard(
          title: "Configuration Boutique",
          icon: Icons.storefront_rounded,
          color: AppColors.primary,
          steps: [
            _RoadmapStep(
              number: "1",
              title: "Créer une boutique",
              description: "Définissez votre point de vente principal.",
              onTap: () async {
                final res = await Get.to(() => const EditionBoutiquePage());
                if (res != null) {
                  ctl.user.hasBoutique = true;
                  ctl.update();
                }
              },
            ),
            _RoadmapStep(
              number: "2",
              title: "Création des modèles",
              description: "Ajoutez vos modèles de base (ex: Robe, Tunique).",
              onTap: () => Get.to(() => const ModeleListPage()),
              enabled: ctl.user.hasBoutique,
            ),
            _RoadmapStep(
              number: "3",
              title: "Création des modèles boutique",
              description:
                  "Définissez les modèles associés à votre boutique avec leurs tarifs.",
              onTap: () => Get.to(() => const ModeleListBoutiquePage()),
              enabled: ctl.user.hasBoutique,
            ),
          ],
        ),

        const Gap(24),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OU",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const Gap(24),

        // Section Succursale (Atelier)
        _buildSectionCard(
          title: "Configuration Succursale (Atelier)",
          icon: Icons.precision_manufacturing_rounded,
          color: Colors.deepOrange,
          steps: [
            _RoadmapStep(
              number: "1",
              title: "Créer une succursale",
              description: "Ajoutez votre atelier de production.",
              onTap: () async {
                final res = await Get.to(() => const EditionSurcusalePage());
                if (res != null) {
                  ctl.user.hasSuccursale = true;
                  ctl.update();
                }
              },
            ),
            _RoadmapStep(
              number: "2",
              title: "Types et catégories de mesures",
              description:
                  "Ajoutez des mensurations par type (ex: carrure, épaule pour Robe).",
              onTap: () => Get.to(() => const TypeMesureListPage()),
              enabled: ctl.user.hasSuccursale,
            ),
          ],
        ),

        const Gap(40),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<_RoadmapStep> steps,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Gap(10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color.withAlpha(220),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: steps.asMap().entries.map((entry) {
                final isLast = entry.key == steps.length - 1;
                final step = entry.value;
                return Column(
                  children: [
                    InkWell(
                      onTap: step.enabled ? step.onTap : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Opacity(
                        opacity: step.enabled ? 1.0 : 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: step.enabled
                                      ? color.withAlpha(30)
                                      : Colors.grey.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  step.number,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: step.enabled ? color : Colors.grey,
                                  ),
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: step.enabled
                                            ? Colors.black87
                                            : Colors.grey,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      step.description,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(8),
                              if (step.enabled)
                                Icon(Icons.chevron_right_rounded,
                                    color: Colors.grey[400]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Row(
                        children: [
                          const Gap(15),
                          Container(
                            width: 2,
                            height: 20,
                            color: color.withAlpha(30),
                          ),
                          const Gap(15),
                        ],
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadmapStep {
  final String number;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool enabled;

  const _RoadmapStep({
    required this.number,
    required this.title,
    required this.description,
    required this.onTap,
    this.enabled = true,
  });
}
