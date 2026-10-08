import 'package:ateliya/data/models/ligne_module_abonnement.dart';
import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/controllers/abonnements/forfait_list_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/detail_forfait_sub_page.dart';
import 'package:ateliya/views/static/abonnements/operator_list_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ForfaitListPage extends StatefulWidget {
  const ForfaitListPage({super.key});

  @override
  State<ForfaitListPage> createState() => _ForfaitListPageState();
}

class _ForfaitListPageState extends State<ForfaitListPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.87);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ForfaitListPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7FAF8),
          appBar: AppBar(
            title: const Text("Formules & Abonnements"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.6),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          color: AppColors.secondary,
                          size: 16,
                        ),
                        Gap(4),
                        Text(
                          "PRO",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: ctl.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : ctl.forfaits.isEmpty
                  ? _buildEmptyState(context)
                  : SafeArea(
                      child: Column(
                        children: [
                          const Gap(8),
                          // En-tête éditorial chic
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                const Text(
                                  "Élevez le standard de votre atelier",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0A2B23),
                                    letterSpacing: -0.4,
                                    height: 1.2,
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  "Des formules pensées pour digitaliser vos commandes, mesures et collaborateurs en toute sérénité.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(14),

                          // Indicateur de pagination raffiné
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              ctl.forfaits.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                height: 5,
                                width: _currentPage == index ? 24 : 6,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? AppColors.primary
                                      : AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const Gap(14),

                          // Carrousel de cartes
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: ctl.forfaits.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, i) {
                                final forfait = ctl.forfaits[i];
                                final isPopular = i == 0 ||
                                    forfait.libelle.value
                                        .toLowerCase()
                                        .contains('pro') ||
                                    forfait.libelle.value
                                        .toLowerCase()
                                        .contains('bus');

                                return AnimatedBuilder(
                                  animation: _pageController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (_pageController
                                        .position.haveDimensions) {
                                      value = _pageController.page! - i;
                                      value = (1 - (value.abs() * 0.08))
                                          .clamp(0.92, 1.0);
                                    } else {
                                      value = i == 0 ? 1.0 : 0.92;
                                    }
                                    return Center(
                                      child: Transform.scale(
                                        scale: value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: _AteliyaPlanCard(
                                    forfait: forfait,
                                    isPopular: isPopular,
                                    index: i,
                                  ),
                                );
                              },
                            ),
                          ),
                          const Gap(14),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_membership_rounded,
              size: 56,
              color: AppColors.primary,
            ),
          ),
          const Gap(20),
          const Text(
            'Aucune formule disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2620),
            ),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Nos offres d\'abonnement sont actuellement en cours d\'actualisation.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AteliyaPlanCard extends StatelessWidget {
  final ModuleAbonnement forfait;
  final bool isPopular;
  final int index;

  const _AteliyaPlanCard({
    required this.forfait,
    required this.isPopular,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isPopular
              ? AppColors.secondary.withValues(alpha: 0.55)
              : AppColors.primary.withValues(alpha: 0.12),
          width: isPopular ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular
                ? AppColors.secondary.withValues(alpha: 0.1)
                : AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : Badge Atelier & Pill de Période
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge de catégorie Ateliya
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPopular
                      ? AppColors.secondary.withValues(alpha: 0.12)
                      : AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isPopular
                        ? AppColors.secondary.withValues(alpha: 0.3)
                        : AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPopular
                          ? Icons.star_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 13,
                      color: isPopular
                          ? AppColors.secondary
                          : AppColors.primary,
                    ),
                    const Gap(5),
                    Text(
                      isPopular ? "RECOMMANDÉ" : "FORMULE ATELIER",
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: isPopular
                            ? AppColors.secondary
                            : AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Pilule de durée avec icône calendrier
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 12,
                      color: AppColors.primary,
                    ),
                    const Gap(4),
                    Text(
                      "${forfait.duree} mois",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(14),

          // Titre de la formule
          Text(
            forfait.libelle.value.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Color(0xFF07241D),
              letterSpacing: 0.2,
            ),
          ),
          const Gap(6),

          // Prix et devise
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                forfait.montant.toAmount(unit: ""),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -0.6,
                ),
              ),
              const Gap(5),
              const Text(
                "FCFA",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
              const Gap(6),
              Text(
                "/ mois",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const Gap(8),

          // Accroche valeur personnalisée couture
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: AppColors.secondary,
                ),
                const Gap(6),
                Expanded(
                  child: Text(
                    "Gestion complète commandes, mesures & stocks",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(14),

          // Séparateur Modules stylisé
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "CAPACITÉS & QUOTAS",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary.withValues(alpha: 0.45),
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  thickness: 1,
                ),
              ),
            ],
          ),
          const Gap(10),

          // Capsules de modules fluides
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: forfait.ligneModules.isNotEmpty
                  ? forfait.ligneModules
                      .map((mod) => _buildModuleCapsule(context, mod))
                      .toList()
                  : [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          forfait.description.value.isNotEmpty
                              ? forfait.description.value
                              : "Tous les modules nécessaires pour la gestion de votre atelier sont inclus.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                    ],
            ),
          ),
          const Gap(12),

          // Bouton d'action "Choisir cette formule" aux couleurs Ateliya
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primary,
                    Color(0xFF135043),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Get.to(() => OperatorListPage(forfait)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flash_on_rounded,
                      color: AppColors.yellow,
                      size: 19,
                    ),
                    Gap(8),
                    Text(
                      "Choisir cette formule",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Capsule de module élégante aux teintes Ateliya
  Widget _buildModuleCapsule(BuildContext context, LigneModuleAbonnement mod) {
    final lowerLib = mod.libelle.value.toLowerCase();
    String friendlyTitle = mod.libelle.value;
    IconData iconData = Icons.layers_outlined;

    if (lowerLib.contains('sms')) {
      friendlyTitle = "Notifications SMS clients";
      iconData = Icons.sms_outlined;
    } else if (lowerLib.contains('user') || lowerLib.contains('utilisat')) {
      friendlyTitle = "Comptes collaborateurs";
      iconData = Icons.people_outline_rounded;
    } else if (lowerLib.contains('succursale') || lowerLib.contains('atelier')) {
      friendlyTitle = "Ateliers & Succursales";
      iconData = Icons.storefront_outlined;
    } else if (lowerLib.contains('boutique')) {
      friendlyTitle = "Boutiques de vente";
      iconData = Icons.shopping_bag_outlined;
    } else if (lowerLib.contains('mall')) {
      friendlyTitle = "Marketplace Mall Ateliya";
      iconData = Icons.public_outlined;
    }

    final String qty = mod.quantite.value;
    final bool isIncluded = qty != '0' &&
        !mod.description.value.toLowerCase().contains('non');

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isIncluded
            ? const Color(0xFFF3F7F5)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isIncluded
              ? AppColors.primary.withValues(alpha: 0.06)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          // Pastille icône avec quantité intégrée
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isIncluded ? AppColors.primary : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  iconData,
                  size: 13,
                  color: Colors.white,
                ),
                if (isIncluded && qty.isNotEmpty && qty != '0') ...[
                  const Gap(4),
                  Text(
                    qty,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Gap(10),
          // Titre
          Expanded(
            child: Text(
              friendlyTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isIncluded ? FontWeight.w700 : FontWeight.w500,
                color: isIncluded
                    ? const Color(0xFF0F2620)
                    : Colors.grey.shade400,
              ),
            ),
          ),
          // Icône d'information (i)
          InkWell(
            onTap: () {
              CBottomSheet.show(
                child: DetailForfaitSubPage(forfait),
                isScrollControlled: true,
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: isIncluded
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
