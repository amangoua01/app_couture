import 'package:ateliya/data/models/mall_favori.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/mall_ya/mes_favoris_vctl.dart';
import 'package:ateliya/views/static/mall_ya/favori_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MesFavorisPage extends StatelessWidget {
  const MesFavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MesFavorisVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
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
                          Color(0xFF0D5040),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                    padding: EdgeInsets.fromLTRB(
                        16, MediaQuery.of(context).padding.top + 56, 16, 20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(12),
                        Text(
                          'Mes favoris',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Gap(6),
                        Text(
                          'Vos modèles préférés en un coup d\'œil',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white54,
                          ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_rounded,
                              color: Colors.white, size: 16),
                          const Gap(6),
                          Text(
                            '${ctl.favoris.length} favori${ctl.favoris.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
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
              ctl.favoris.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Aucun favori enregistré.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _FavoriTile(
                              item: ctl.favoris[i],
                              onTap: () => Get.to(() =>
                                  FavoriDetailPage(favori: ctl.favoris[i])),
                            ),
                          ),
                          childCount: ctl.favoris.length,
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

class _FavoriTile extends StatelessWidget {
  final MallFavori item;
  final VoidCallback onTap;
  const _FavoriTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mb = item.modeleBoutique;
    final photoUrl = mb?.modele?.photo?.fullUrl;
    final prix = double.tryParse(mb?.prix ?? '0') ?? 0;
    final fmt = NumberFormat('#,###', 'fr_FR');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
              child: photoUrl != null
                  ? Image.network(photoUrl,
                      width: 64, height: 64, fit: BoxFit.cover)
                  : Container(
                      width: 64,
                      height: 64,
                      color: const Color(0xFFE8F5E9),
                      child: const Icon(Icons.checkroom_rounded,
                          color: Color(0xFF062A22), size: 28),
                    ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mb?.modele?.libelle ?? '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF062A22),
                    ),
                  ),
                  if (mb?.boutique != null) ...[
                    const Gap(2),
                    Text(
                      mb!.boutique!.libelle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (mb.boutique!.situation.isNotEmpty)
                      Text(
                        mb.boutique!.situation,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                  ],
                  const Gap(4),
                  Text(
                    '${fmt.format(prix)} FCFA',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: Color(0xFFC2185B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
