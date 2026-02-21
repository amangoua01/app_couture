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
        final abonnementsActifs = ctl.abonnements.where((a) => a.etat).length;
        final abonnementsInactifs =
            ctl.abonnements.where((a) => !a.etat).length;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text("Mes Abonnements"),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: ctl.fetchAbonnements,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Get.to(() => const ForfaitListPage()),
            icon: const Icon(Icons.add),
            label: const Text('Nouveau'),
            backgroundColor: AppColors.primary,
          ),
          body: ctl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ctl.abonnements.isEmpty
                  ? _buildEmptyState(context)
                  : RefreshIndicator(
                      onRefresh: ctl.fetchAbonnements,
                      child: CustomScrollView(
                        slivers: [
                          // Header avec statistiques
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.primary, AppColors.green],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tableau de bord',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatCard(
                                          'Total',
                                          ctl.abonnements.length.toString(),
                                          Icons.subscriptions,
                                          Colors.white,
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Actifs',
                                          abonnementsActifs.toString(),
                                          Icons.check_circle,
                                          Colors.green,
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Inactifs',
                                          abonnementsInactifs.toString(),
                                          Icons.cancel,
                                          Colors.orange,
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
                            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                      child: AbonnementTile(
                                          ctl.abonnements[index]),
                                    ),
                                  );
                                },
                                childCount: ctl.abonnements.length,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const Gap(5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
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
