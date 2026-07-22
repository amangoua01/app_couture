import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_modeles_vctl.dart';
import 'package:ateliya/views/static/mall_ya/mall_detail_modele_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_lot_promotions_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_lot_nouveautes_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MallModelesPage extends StatelessWidget {
  const MallModelesPage({super.key});

  void _showArchives(BuildContext context, MallModelesVctl ctl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F7FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.archive_rounded, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Modèles archivés',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF062A22),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Appuyez sur un modèle pour le réactiver',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: ctl.modelesArchives.length,
                  itemBuilder: (_, i) {
                    final item = ctl.modelesArchives[i];
                    final photoUrl = item.modele?.photo?.fullUrl;
                    final prix = double.tryParse(item.prix) ?? 0;
                    final fmt = NumberFormat('#,###', 'fr_FR');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () async {
                          await ctl.reactiverModele(item.id);
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3)),
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
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _archivePlaceholder())
                                    : _archivePlaceholder(),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.modele?.libelle ?? '—',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: Color(0xFF062A22),
                                      ),
                                    ),
                                    const Gap(2),
                                    Text(
                                      '${fmt.format(prix)} FCFA',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFC2185B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.restore_rounded,
                                        color: Colors.orange, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Réactiver',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _archivePlaceholder() => Container(
        width: 56,
        height: 56,
        color: const Color(0xFFFFF3E0),
        child:
            const Icon(Icons.checkroom_rounded, color: Colors.orange, size: 24),
      );

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return GetBuilder(
      init: MallModelesVctl(),
      autoRemove: false,
      builder: (ctl) {
        final items = ctl.filtered;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 180,
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
                    padding: EdgeInsets.fromLTRB(16, topPadding + 56, 16, 20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(12),
                        Text(
                          'Mes modèles',
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
                          'Gérez la visibilité de vos modèles sur le Mall.',
                          style: TextStyle(fontSize: 12, color: Colors.white54),
                        ),
                        Gap(16),
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
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.checkroom_rounded,
                              color: Colors.white, size: 15),
                          const Gap(6),
                          Text(
                            '${items.length} modèle${items.length > 1 ? 's' : ''}',
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
                    if (ctl.modelesArchives.isNotEmpty)
                      GestureDetector(
                        onTap: () => _showArchives(context, ctl),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.4)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.archive_rounded,
                                  color: Colors.orange, size: 20),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${ctl.modelesArchives.length}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 40),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _TabBtn(
                            label: 'Tous',
                            index: 0,
                            current: ctl.tabIndex,
                            onTap: ctl.setTab),
                        _TabBtn(
                            label: 'Nouveautés',
                            index: 1,
                            current: ctl.tabIndex,
                            onTap: ctl.setTab),
                        _TabBtn(
                            label: 'Promotions',
                            index: 2,
                            current: ctl.tabIndex,
                            onTap: ctl.setTab),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: ctl.setSearch,
                            decoration: InputDecoration(
                              hintText: 'Rechercher...',
                              hintStyle: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                              prefixIcon: const Icon(Icons.search_rounded,
                                  color: Colors.grey, size: 20),
                              suffixIcon: ctl.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded,
                                          size: 18, color: Colors.grey),
                                      onPressed: () => ctl.setSearch(''),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: PopupMenuButton<int?>(
                          onSelected: ctl.setBoutique,
                          initialValue: ctl.selectedBoutiqueId,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: null,
                              child: Text('Toutes les boutiques',
                                  style: TextStyle(fontSize: 13)),
                            ),
                            ...ctl.boutiqueOptions.map(
                              (b) => PopupMenuItem(
                                value: b.id,
                                child: Text(b.libelle,
                                    style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.storefront_rounded,
                                  size: 20,
                                  color: ctl.selectedBoutiqueId != null
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                                const Gap(4),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 18,
                                  color: ctl.selectedBoutiqueId != null
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              items.isEmpty && ctl.loading
                  ? const SliverFillRemaining(
                      child: _ModelesSkeleton(),
                    )
                  : items.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text('Aucun modèle trouvé.',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, i) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await Get.to(() =>
                                        MallDetailModelePage(item: items[i]));
                                    if (result == 'deleted') ctl.loadModeles();
                                  },
                                  child: _ModeleTile(item: items[i]),
                                ),
                              ),
                              childCount: items.length,
                            ),
                          ),
                        ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _FabAction(
                icon: Icons.auto_awesome,
                label: 'Nouveauté',
                color: const Color(0xFF1565C0),
                onTap: ctl.modeles.isEmpty
                    ? null
                    : () async {
                        final res = await Get.to(
                            () => MallLotNouveautesPage(modeles: ctl.modeles));
                        if (res == true) ctl.loadModeles();
                      },
              ),
              const Gap(10),
              _FabAction(
                icon: Icons.local_offer_rounded,
                label: 'Promotion',
                color: const Color(0xFFC2185B),
                onTap: ctl.modeles.isEmpty
                    ? null
                    : () async {
                        final res = await Get.to(
                            () => MallLotPromotionsPage(modeles: ctl.modeles));
                        if (res == true) ctl.loadModeles();
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  const _TabBtn({
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? const Color(0xFF062A22) : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeleTile extends StatelessWidget {
  final MallModeleBoutique item;

  const _ModeleTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final photoUrl = item.modele?.photo?.fullUrl;
    final prix = double.tryParse(item.prix) ?? 0;
    final fmt = NumberFormat('#,###', 'fr_FR');

    return Container(
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
                ? Image.network(
                    photoUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.modele?.libelle ?? '—',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF062A22),
                  ),
                ),
                if (item.boutique != null) ...[
                  const Gap(2),
                  Text(
                    item.boutique!.libelle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (item.boutique!.situation.isNotEmpty)
                    Text(
                      item.boutique!.situation,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                ],
                const Gap(4),
                Row(
                  children: [
                    Text(
                      '${fmt.format(prix)} FCFA',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: Color(0xFFC2185B),
                      ),
                    ),
                    const Gap(6),
                    if (item.isNouveaute)
                      const _Badge(label: 'Nouveau', color: Color(0xFF1565C0)),
                    if (item.isPromotion)
                      const _Badge(label: 'Promo', color: Color(0xFFC2185B)),
                    if (item.isSurMesure == true)
                      const _Badge(
                          label: 'Sur mesure', color: Color(0xFF6A1B9A)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 64,
        height: 64,
        color: const Color(0xFFE8F5E9),
        child: const Icon(Icons.checkroom_rounded,
            color: Color(0xFF062A22), size: 28),
      );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style:
            TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

class _FabAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _FabAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const Gap(6),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModelesSkeleton extends StatelessWidget {
  const _ModelesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
