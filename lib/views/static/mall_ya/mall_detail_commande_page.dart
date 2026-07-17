import 'package:ateliya/data/models/mall_dashboard_stats.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/env.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MallDetailCommandePage extends StatelessWidget {
  final MallRecentOrder order;
  const MallDetailCommandePage({super.key, required this.order});

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

  String get _formattedDate {
    try {
      final dt = DateTime.parse(order.dateCommande);
      return DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR').format(dt);
    } catch (_) {
      return order.dateCommande;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'fr_FR');
    final total = int.tryParse(order.montantTotal) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commande #${order.id}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            Text(
              _formattedDate,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // Boutique + statut sur la même ligne
          _SectionCard(
            title: 'Boutique',
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF062A22).withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.storefront_rounded,
                          size: 15, color: Color(0xFF062A22)),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        order.entrepriseLibelle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF062A22),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (order.entrepriseNumero.isNotEmpty) ...[
                  const Gap(10),
                  _InfoRow(
                    icon: Icons.phone_rounded,
                    label: 'Téléphone',
                    value: order.entrepriseNumero,
                  ),
                ],
                if (order.entrepriseEmail.isNotEmpty) ...[
                  const Gap(10),
                  _InfoRow(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    value: order.entrepriseEmail,
                  ),
                ],
              ],
            ),
          ),
          const Gap(14),
          // Articles
          _SectionCard(
            title: 'Articles commandés',
            child: Column(
              children: order.lignes
                  .map((ligne) => _LigneTile(ligne: ligne, fmt: fmt))
                  .toList(),
            ),
          ),
          const Gap(14),
          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF062A22),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Montant total',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${fmt.format(total)} F',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

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
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF062A22),
            ),
          ),
          const Gap(12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

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
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF062A22))),
          ],
        ),
      ],
    );
  }
}

class _LigneTile extends StatelessWidget {
  final MallLigneCommande ligne;
  final NumberFormat fmt;
  const _LigneTile({required this.ligne, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        ligne.photoUrl != null ? Env.fullImageUrl(ligne.photoUrl!) : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: 52,
                    height: 52,
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
                  ligne.modeleLibelle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF062A22),
                  ),
                ),
                const Gap(2),
                Text(
                  ligne.boutiqueLibelle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const Gap(2),
                Text(
                  'Qté : ${ligne.quantite}  ×  ${fmt.format(int.tryParse(ligne.prixUnitaire) ?? 0)} F',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${fmt.format(ligne.total)} F',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: Color(0xFF062A22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF062A22).withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.checkroom_rounded,
          color: Color(0xFF062A22), size: 24),
    );
  }
}
