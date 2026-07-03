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
    _pageController = PageController(viewportFraction: 0.85);
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
          backgroundColor: const Color(0xFFF4F7F9),
          body: ctl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ctl.forfaits.isEmpty
                  ? _buildEmptyState(context)
                  : Stack(
                      children: [
                        // Dark Premium Background Header
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 340,
                          child: Container(
                            color: AppColors.primary,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -40,
                                  top: 40,
                                  child: Icon(
                                    Icons.auto_awesome,
                                    size: 180,
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SafeArea(
                          bottom: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Interactive Back Button & Header Text
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_ios_new,
                                      color: Colors.white),
                                  onPressed: () => Get.back(),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Boostez votre activité !",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      "Choisissez la formule qui correspond le mieux aux besoins de votre atelier.",
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.78),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(32),

                              // Horizontal Carousel
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
                                    final isPremium = forfait.libelle.value
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
                                          value = (1 - (value.abs() * 0.15))
                                              .clamp(0.85, 1.0);
                                        } else {
                                          value = i == 0 ? 1.0 : 0.85;
                                        }
                                        return Center(
                                          child: SizedBox(
                                            height: Curves.easeOut
                                                    .transform(value) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.65,
                                            width: double.infinity,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: _PlanCard(
                                          forfait: forfait,
                                          isPremium: isPremium),
                                    );
                                  },
                                ),
                              ),
                              const Gap(24),
                              // Pagination Dots
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  ctl.forfaits.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    height: 8,
                                    width: _currentPage == index ? 24 : 8,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(32),
                            ],
                          ),
                        ),
                      ],
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
              color: AppColors.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.card_membership_rounded,
                size: 64, color: AppColors.primary),
          ),
          const Gap(24),
          const Text(
            'Aucune offre pour le moment',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Nos forfaits sont en cours de mise à jour. Nous revenons très vite !',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final ModuleAbonnement forfait;
  final bool isPremium;

  const _PlanCard({required this.forfait, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPremium
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          width: isPremium ? 2 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isPremium
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        forfait.libelle.value.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Gap(4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${forfait.duree} mois",
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      "POPULAIRE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  forfait.montant.toAmount(unit: ""),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F231F),
                    letterSpacing: -1,
                  ),
                ),
                const Gap(4),
                Text(
                  "FCFA",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Divider(color: AppColors.primary.withValues(alpha: 0.06), height: 1),
            const Gap(16),

            // Expanded Features List to take available space
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (forfait.ligneModules.isNotEmpty) ...[
                      ...forfait.ligneModules.map((line) {
                        final isIncluded = line.quantite.value != '0' &&
                            !line.description.value.toLowerCase().contains('non');
                        final itemColor = isIncluded
                            ? const Color(0xFF0F231F)
                            : const Color(0xFF90A39E);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  isIncluded
                                      ? Icons.check_circle_rounded
                                      : Icons.remove_circle_outline_rounded,
                                  size: 18,
                                  color: isIncluded
                                      ? Colors.green.shade600
                                      : Colors.grey.shade400,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: itemColor,
                                      height: 1.35,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "${line.libelle.value} ",
                                        style: TextStyle(
                                          fontWeight: isIncluded
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),
                                      ),
                                      if (line.quantite.value != '0')
                                        TextSpan(
                                          text: "(${line.quantite.value})",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: isIncluded
                                                ? AppColors.primary
                                                : Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ] else
                      Text(
                        forfait.description.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const Gap(14),
            // Bottom Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => OperatorListPage(forfait)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Souscrire",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => CBottomSheet.show(
                      child: DetailForfaitSubPage(forfait),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Voir les détails",
                      style: TextStyle(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
