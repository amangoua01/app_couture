import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/forfait_list_page.dart';
import 'package:ateliya/views/static/home/home_page/annexe/activite_part.dart';
import 'package:ateliya/views/static/home/home_page/annexe/vente_button.dart';
import 'package:ateliya/views/static/home/home_page/annexe/caisse_wallet_card_state.dart';
import 'package:ateliya/views/static/home/home_page/widgets/inline_stats_bar.dart';
import 'package:ateliya/views/static/home/widgets/roadmap_onboarding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomePageVctl(),
        builder: (ctl) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: MainAppBar(
              enterpriseTitle: ctl.getEntite().value.libelle.value,
              notifCount: ctl.nbUnreadNotifs,
              onSelectionChanged: () {
                ctl.loadData();
                ctl.update();
              },
              onNotifRefresh: () => ctl.loadUnreadCount(),
            ),
            floatingActionButton: VenteButton(ctl: ctl),
            body: PlaceholderWidget(
              condition: ctl.getEntite().value.isNotEmpty,
              placeholder: ternaryFn(
                condition: ctl.user.isAdmin,
                ifTrue: RoadmapOnboardingWidget(ctl),
                ifFalse: Center(
                  child: Text(
                    "Aucune boutique ou succursale sélectionnée.\nVeuillez contacter votre administrateur.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              child: RefreshIndicator(
                onRefresh: ctl.loadData,
                child: PlaceholderWidget(
                  condition: !ctl.presentSubscription,
                  placeholder: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                width: 3,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              "assets/images/svg/atelier.svg",
                              height: 60,
                              width: 60,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Abonnement expiré",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Votre abonnement actuel n'est plus actif. Veuillez le renouveler pour continuer à utiliser toutes les fonctionnalités de l'application.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Visibility(
                            visible: ctl.user.isAdmin,
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withValues(alpha: 0.9),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: TextButton.icon(
                                onPressed: () =>
                                    Get.to(() => const ForfaitListPage()),
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                label: const Text(
                                  "Gérer mon abonnement",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: ListView(
                    controller: ctl.scrollCtl,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    children: [
                      CaisseWalletCard(
                        ctl: ctl,
                        obscureBalance: ctl.obscureBalance,
                        onToggleObscure: ctl.toggleObscureBalance,
                      ),
                      const Gap(24),
                      Visibility(
                        visible: ctl.getEntite().value.type ==
                            EntiteEntrepriseType.succursale,
                        child: Column(
                          children: [
                            InlineStatsBar(
                              items: [
                                StatItem(
                                  icon: Icons.pending_actions_rounded,
                                  label: "En cours",
                                  value:
                                      "${ctl.data.commandes.where((e) => e.isActive).length}",
                                  color: AppColors.primary,
                                ),
                                StatItem(
                                  icon: Icons.check_circle_outline_rounded,
                                  label: "Terminées",
                                  value:
                                      "${ctl.data.commandes.where((e) => !e.isActive).length}",
                                  color: AppColors.green,
                                ),
                              ],
                            ),
                            const Gap(24),
                          ],
                        ),
                      ),
                      ActivitePart(ctl: ctl)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
