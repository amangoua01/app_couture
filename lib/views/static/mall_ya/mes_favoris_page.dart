import 'package:ateliya/data/models/mall_favori.dart';
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
          appBar: AppBar(
            title: const Text(
              'Mes favoris',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            backgroundColor: const Color(0xFF062A22),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: ctl.favoris.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun favori enregistré.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  itemCount: ctl.favoris.length,
                  separatorBuilder: (_, __) => const Gap(10),
                  itemBuilder: (_, i) => _FavoriTile(
                    item: ctl.favoris[i],
                    onTap: () => Get.to(
                      () => FavoriDetailPage(favori: ctl.favoris[i]),
                    ),
                  ),
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
