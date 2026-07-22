import 'package:ateliya/data/models/mall_dashboard_stats.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/env.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/views/controllers/mall_ya/mes_commandes_vctl.dart';
import 'package:ateliya/views/static/mall_ya/mall_detail_commande_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MesCommandesPage extends StatelessWidget {
  const MesCommandesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return GetBuilder(
      init: MesCommandesVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                backgroundColor: const Color(0xFF062A22),
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF062A22),
                          AppColors.primary,
                          Color(0xFF0D5040)
                        ],
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                    padding: EdgeInsets.fromLTRB(16, topPadding + 56, 16, 20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(12),
                        Text(
                          'Mes commandes',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Gap(4),
                        Text(
                          'Historique de vos achats sur le Mall.',
                          style: TextStyle(fontSize: 12, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 17),
                      ),
                    ),
                    const Spacer(),
                    if (!ctl.loading)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag_rounded,
                                color: Colors.white, size: 15),
                            const Gap(6),
                            Text(
                              '${ctl.commandes.length} commande${ctl.commandes.length > 1 ? 's' : ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              if (ctl.loading)
                const SliverFillRemaining(child: _CommandesSkeleton())
              else if (ctl.commandes.isEmpty)
                const SliverFillRemaining(
                  child: EmptyPage(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Aucune commande',
                    subtitle: 'Vous n\'avez pas encore passé de commande.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => Get.to(() => MallDetailCommandePage(
                                order: ctl.commandes[i],
                                showActions: false,
                              )),
                          child: _CommandeTile(order: ctl.commandes[i]),
                        ),
                      ),
                      childCount: ctl.commandes.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CommandeTile extends StatelessWidget {
  final MallRecentOrder order;
  const _CommandeTile({required this.order});

  Color get _statusColor {
    switch (order.statut) {
      case 'EN_ATTENTE':
        return const Color(0xFFB8860B);
      case 'VALIDEE':
        return const Color(0xFF0A7A5A);
      case 'LIVREE':
        return const Color(0xFF1565C0);
      case 'ANNULEE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get _statusLabel {
    switch (order.statut) {
      case 'EN_ATTENTE':
        return 'En attente';
      case 'VALIDEE':
        return 'Validée';
      case 'LIVREE':
        return 'Livrée';
      case 'ANNULEE':
        return 'Annulée';
      default:
        return order.statut;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'fr_FR');
    final amount = int.tryParse(order.montantTotal) ?? 0;
    final logoUrl = order.entrepriseLogo != null
        ? Env.fullImageUrl(order.entrepriseLogo!)
        : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: logoUrl != null
                ? Image.network(logoUrl,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _logoPlaceholder())
                : _logoPlaceholder(),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.entrepriseLibelle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF062A22),
                  ),
                ),
                const Gap(3),
                Text(
                  _formatDate(order.dateCommande),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const Gap(3),
                Text(
                  '${order.lignes.length} article${order.lignes.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${fmt.format(amount)} F',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Color(0xFF062A22),
                ),
              ),
              const Gap(6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _logoPlaceholder() => Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFB8860B).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.storefront_rounded,
            color: Color(0xFFB8860B), size: 22),
      );

  String _formatDate(String raw) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm', 'fr_FR')
          .format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }
}

class _CommandesSkeleton extends StatelessWidget {
  const _CommandesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
