import 'package:ateliya/data/models/mall_favori.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/controllers/mall_ya/mes_favoris_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FavoriDetailPage extends StatelessWidget {
  final MallFavori favori;
  const FavoriDetailPage({super.key, required this.favori});

  @override
  Widget build(BuildContext context) {
    final mb = favori.modeleBoutique;
    final modele = mb?.modele;
    final boutique = mb?.boutique;
    final photoUrl = modele?.photo?.fullUrl;
    final prix = double.tryParse(mb?.prix ?? '0') ?? 0;
    final fmt = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF062A22),
            foregroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: photoUrl != null
                  ? Image.network(photoUrl, fit: BoxFit.cover)
                  : Container(
                      color: const Color(0xFFE8F5E9),
                      child: const Icon(Icons.checkroom_rounded,
                          color: Color(0xFF062A22), size: 80),
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Nom + prix
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        modele?.libelle ?? '—',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF062A22),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC2185B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${fmt.format(prix)} FCFA',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Color(0xFFC2185B),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(20),

                // Infos boutique
                if (boutique != null)
                  _InfoCard(
                    icon: Icons.storefront_rounded,
                    title: 'Boutique',
                    children: [
                      _InfoRow(label: 'Nom', value: boutique.libelle),
                      if (boutique.situation.isNotEmpty)
                        _InfoRow(
                            label: 'Localisation', value: boutique.situation),
                    ],
                  ),
                const Gap(12),

                // Date d'ajout
                _InfoCard(
                  icon: Icons.favorite_rounded,
                  title: 'Favori depuis',
                  children: [
                    _InfoRow(
                      label: 'Date',
                      value: _formatDate(favori.dateAjout),
                    ),
                  ],
                ),
                const Gap(32),

                // Bouton retirer
                GetBuilder<MesFavorisVctl>(
                  builder: (ctl) => CButton(
                    title: 'Retirer des favoris',
                    color: const Color(0xFFC2185B),
                    icon: const Icon(Icons.favorite_border_rounded,
                        color: Colors.white, size: 18),
                    onPressed: () async {
                      await ctl.retirer(favori);
                      Get.back();
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('dd MMM yyyy', 'fr_FR').format(dt);
    } catch (_) {
      return raw;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  const _InfoCard(
      {required this.icon, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF062A22), size: 18),
              const Gap(8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF062A22),
                ),
              ),
            ],
          ),
          const Gap(12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF062A22)),
            ),
          ),
        ],
      ),
    );
  }
}
