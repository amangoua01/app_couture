import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Suivi des travaux de l'atelier : les travaux en cours sont l'information
/// principale, mise en avant en grand sur fond doré ; les terminées, simple
/// complément, restent discrètes à côté.
class TravauxStats extends StatelessWidget {
  final int enCours;
  final int terminees;

  const TravauxStats({
    super.key,
    required this.enCours,
    required this.terminees,
  });

  @override
  Widget build(BuildContext context) {
    final total = enCours + terminees;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: _CarteEnCours(nombre: enCours, total: total),
          ),
          const Gap(12),
          Expanded(flex: 3, child: _CarteTerminees(nombre: terminees)),
        ],
      ),
    );
  }
}

class _CarteEnCours extends StatelessWidget {
  final int nombre;
  final int total;
  const _CarteEnCours({required this.nombre, required this.total});

  @override
  Widget build(BuildContext context) {
    final part = total == 0 ? 0.0 : nombre / total;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE2B15B), AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.4),
            blurRadius: 22,
            offset: const Offset(0, 10),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pending_actions_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const Gap(8),
              const Expanded(
                child: Text(
                  'Travaux en cours',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            '$nombre',
            style: const TextStyle(
              fontSize: 34,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: AppColors.primary,
            ),
          ),
          const Gap(8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: part,
              minHeight: 4,
              backgroundColor: AppColors.primary.withValues(alpha: 0.16),
              color: AppColors.primary,
            ),
          ),
          const Gap(4),
          Text(
            total == 0
                ? 'Aucune commande'
                : '$nombre sur $total commande${total > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarteTerminees extends StatelessWidget {
  final int nombre;
  const _CarteTerminees({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 15,
              color: AppColors.green,
            ),
          ),
          const Gap(8),
          Text(
            '$nombre',
            style: const TextStyle(
              fontSize: 24,
              height: 1,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const Gap(2),
          Text(
            'Terminées',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
