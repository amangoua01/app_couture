import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/constants/type_user_enum.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/subscription_banner.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/home/home_page/annexe/activite_part.dart';
import 'package:ateliya/views/static/home/home_page/annexe/caisse_wallet_card_state.dart';
import 'package:ateliya/views/static/home/home_page/annexe/vente_button.dart';
import 'package:ateliya/views/static/home/home_page/widgets/inline_stats_bar.dart';
import 'package:ateliya/views/static/home/widgets/no_entite_selected_view.dart';
import 'package:ateliya/views/static/home/widgets/roadmap_onboarding_widget.dart';
import 'package:flutter/material.dart';
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
          backgroundColor: AppColors.scaffoldBg,
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
              ifFalse: const NoEntiteSelectedView(),
            ),
            child: RefreshIndicator(
              onRefresh: ctl.loadData,
              child: ListView(
                controller: ctl.scrollCtl,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  SubscriptionBanner(
                    visible: ctl.presentSubscription,
                    canManage: ctl.user.isAdmin,
                  ),
                  Visibility(
                    visible: ctl.user.type?.code != TypeUserEnum.ac.code,
                    child: CaisseWalletCard(
                      ctl: ctl,
                      obscureBalance: ctl.obscureBalance,
                      onToggleObscure: ctl.toggleObscureBalance,
                    ),
                  ),
                  const Gap(24),
                  Visibility(
                    visible:
                        ctl.getEntite().value.type ==
                        EntiteEntrepriseType.succursale,
                    child: Column(
                      children: [
                        InlineStatsBar(
                          items: [
                            StatItem(
                              icon: Icons.pending_actions_rounded,
                              label: "Travaux en cours",
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
                  ActivitePart(ctl: ctl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
