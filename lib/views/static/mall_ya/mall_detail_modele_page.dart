import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/static/mall_ya/mall_edition_modele_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MallDetailModelePage extends StatelessWidget {
  final MallModeleBoutique item;

  const MallDetailModelePage({super.key, required this.item});

  Future<void> _delete() async {
    final confirm = await CChoiceMessageDialog.show(
      message: 'Voulez-vous vraiment supprimer ce modèle du mall ?',
      validText: 'Supprimer',
      cancelText: 'Annuler',
      secondaryColor: Colors.red,
    );
    if (confirm != true) return;
    final res = await MallApi().deleteModele(item.id).load();
    if (res.status) {
      CSnackbar.show(message: 'Modèle supprimé avec succès', isSuccess: true);
      Get.back(result: 'deleted');
    } else {
      CSnackbar.show(message: res.message ?? 'Erreur inconnue');
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = item.modele?.photo?.fullUrl;
    final prix = double.tryParse(item.prix) ?? 0;
    final fmt = NumberFormat('#,###', 'fr_FR');
    final promo = item.activePromo;
    final nouveau = item.activeNouveau;
    final prixPromo = promo?.prixPromotion != null
        ? double.tryParse(promo!.prixPromotion!)
        : null;
    final prixNouv = nouveau?.prixNouveau != null
        ? double.tryParse(nouveau!.prixNouveau!)
        : null;
    final prixUnite = promo?.prixUnite != null
        ? double.tryParse(promo!.prixUnite!)
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            collapsedHeight: 80,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF062A22),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: photoUrl != null
                  ? Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _photoPlaceholder(),
                    )
                  : _photoPlaceholder(),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 17),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                        Text(
                          item.modele?.libelle ?? '—',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF062A22),
                          ),
                        ),
                        const Gap(8),
                        // Badges
                        if (item.isNouveaute || item.isPromotion || item.isSurMesure == true)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Wrap(
                              spacing: 6,
                              children: [
                                if (item.isNouveaute)
                                  _Badge(label: 'Nouveau', color: const Color(0xFF1565C0)),
                                if (item.isPromotion)
                                  _Badge(label: 'Promo', color: const Color(0xFFC2185B)),
                                if (item.isSurMesure == true)
                                  _Badge(label: 'Sur mesure', color: const Color(0xFF6A1B9A)),
                              ],
                            ),
                          ),
                        // Prix original barré si promo/nouveau
                        if (prixPromo != null || prixNouv != null)
                          Text(
                            '${fmt.format(prix)} FCFA',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        // Prix promo
                        if (prixPromo != null) ...[
                          const Gap(2),
                          Text(
                            '${fmt.format(prixPromo)} FCFA',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFC2185B),
                            ),
                          ),
                          if (prixUnite != null)
                            Text(
                              '${fmt.format(prixUnite)} FCFA / unité',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          if (promo?.dateFinPromotion != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.timer_outlined,
                                      size: 13, color: Color(0xFFC2185B)),
                                  const Gap(4),
                                  Text(
                                    'Fin : ${_formatDate(promo!.dateFinPromotion!)}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFC2185B),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                        ] else if (prixNouv != null) ...[
                          const Gap(2),
                          Text(
                            '${fmt.format(prixNouv)} FCFA',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ] else
                          Text(
                            '${fmt.format(prix)} FCFA',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFC2185B),
                            ),
                          ),
                        if (item.boutique != null) ...[
                          const Gap(12),
                          const Divider(height: 1),
                          const Gap(12),
                          _InfoRow(
                            icon: Icons.storefront_rounded,
                            label: 'Boutique',
                            value: item.boutique!.libelle,
                          ),
                          if (item.boutique!.situation.isNotEmpty) ...[
                            const Gap(10),
                            _InfoRow(
                              icon: Icons.location_on_rounded,
                              label: 'Situation',
                              value: item.boutique!.situation,
                            ),
                          ],
                        ],
                        const Gap(12),
                        const Divider(height: 1),
                        const Gap(12),
                        _InfoRow(
                          icon: item.isActive
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          label: 'Statut',
                          value: item.isActive ? 'Actif' : 'Inactif',
                          valueColor: item.isActive
                              ? const Color(0xFF0A7A5A)
                              : Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.edit_rounded,
                          label: 'Modifier',
                          color: const Color(0xFF062A22),
                          onTap: () =>
                              Get.to(() => MallEditionModelePage(item: item)),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.delete_rounded,
                          label: 'Supprimer',
                          color: Colors.red,
                          onTap: _delete,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder() => Container(
        color: const Color(0xFFE8F5E9),
        child: const Center(
          child:
              Icon(Icons.checkroom_rounded, color: Color(0xFF062A22), size: 80),
        ),
      );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

String _formatDate(String raw) {
  try {
    return DateFormat('dd/MM/yyyy', 'fr_FR').format(DateTime.parse(raw));
  } catch (_) {
    return raw;
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFF062A22).withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: const Color(0xFF062A22)),
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF062A22),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const Gap(8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
