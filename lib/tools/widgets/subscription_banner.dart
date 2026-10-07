import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/static/abonnements/forfait_list_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Bandeau discret signalant que l'abonnement n'est plus actif.
///
/// Remplace l'ancien écran bloquant : l'utilisateur garde l'accès à ses
/// données en lecture, le serveur refusant déjà les actions d'écriture avec
/// son propre message.
class SubscriptionBanner extends StatelessWidget {
  /// N'affiche rien tant que l'abonnement est valide.
  final bool visible;

  /// Seuls les administrateurs peuvent renouveler, les autres voient le motif.
  final bool canManage;

  final EdgeInsetsGeometry margin;

  const SubscriptionBanner({
    required this.visible,
    this.canManage = false,
    this.margin = const EdgeInsets.only(bottom: 16),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.35)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: canManage ? () => Get.to(() => const ForfaitListPage()) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.secondary,
                  size: 20,
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Abonnement expiré",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const Gap(2),
                      Text(
                        canManage
                            ? "Renouvelez pour retrouver toutes les fonctionnalités."
                            : "Contactez votre administrateur pour le renouveler.",
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (canManage) ...[
                  const Gap(8),
                  const Text(
                    "Renouveler",
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
