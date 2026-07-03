import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/abonnement_tile.dart';
import 'package:ateliya/views/controllers/abonnements/abonnements_list_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/forfait_list_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AbonnementsListPage extends StatelessWidget {
  const AbonnementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AbonnementsListPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAF9),
          appBar: AppBar(
            title: const Text("Mes Abonnements"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: ctl.fetchAbonnements,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.to(() => const ForfaitListPage()),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.add, size: 28, weight: 800),
          ),
          body: ctl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ctl.abonnementActif == null && ctl.totalAbonnement == 0
                  ? _buildEmptyState(context)
                  : RefreshIndicator(
                      onRefresh: ctl.fetchAbonnements,
                      child: CustomScrollView(
                        slivers: [
                          // Header avec statistiques (Uniformisé & Sans Dégradé)
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.06),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.analytics_rounded,
                                            color: AppColors.primary,
                                            size: 18,
                                          ),
                                          Gap(8),
                                          Text(
                                            'Tableau de bord',
                                            style: TextStyle(
                                              color: Color(0xFF0F231F),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.06),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Total: ${ctl.totalAbonnement}',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatCard(
                                          'Actifs',
                                          ctl.nombreAbonnementActif.toString(),
                                          Icons.check_circle_outline_rounded,
                                          Colors.green.shade600,
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Inactifs',
                                          ctl.nombreAbonnementPasse.toString(),
                                          Icons.cancel_outlined,
                                          Colors.grey.shade500,
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: _buildStatCard(
                                          'À venir',
                                          ctl.nombreAbonnementPending
                                              .toString(),
                                          Icons.hourglass_empty_rounded,
                                          AppColors.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Liste des abonnements
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return TweenAnimationBuilder(
                                    duration: Duration(
                                        milliseconds: 300 + (index * 100)),
                                    tween: Tween<double>(begin: 0, end: 1),
                                    builder: (context, double value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 50 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: ctl.abonnementActif != null
                                          ? AbonnementTile(
                                              ctl.abonnementActif!,
                                            )
                                          : const SizedBox(),
                                    ),
                                  );
                                },
                                childCount: ctl.abonnementActif != null ? 1 : 0,
                              ),
                            ),
                          ),

                          // Espace en bas pour le FAB
                          const SliverToBoxAdapter(
                            child: Gap(80),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const Gap(8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F231F),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Gap(2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.subscriptions_outlined,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const Gap(20),
          const Text(
            'Aucun abonnement',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Vous n\'avez pas encore d\'abonnement actif.\nCommencez par en créer un !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          const Gap(30),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => const ForfaitListPage()),
            icon: const Icon(Icons.add),
            label: const Text('Créer un abonnement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
