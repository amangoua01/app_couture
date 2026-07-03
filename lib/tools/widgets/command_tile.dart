import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/widgets/paiement_dialog.dart';
import 'package:ateliya/views/controllers/commandes/detail_command_page_vctl.dart';
import 'package:ateliya/views/static/commandes/detail_command_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommandTile extends StatelessWidget {
  final Mesure? mesure;
  const CommandTile({super.key, this.mesure});

  @override
  Widget build(BuildContext context) {
    if (mesure == null) return const SizedBox.shrink();

    final int? joursRestants =
        mesure!.dateRetrait?.difference(DateTime.now()).inDays;

    final bool isCompleted = mesure!.etatFacture == 'Terminée' ||
        mesure!.etatFacture == 'Livrée' ||
        mesure!.etatFacture == 'TERMINE' ||
        mesure!.etatFacture == 'SOLDE';

    final bool isUrgent = !isCompleted &&
        joursRestants != null &&
        joursRestants <= 2 &&
        joursRestants >= 0;

    final etats = mesure!.lignesMesures
        .where((l) => l.etat != null && l.etat!.isNotEmpty)
        .map((l) => l.etat!)
        .toSet()
        .toList();

    final articles = mesure!.lignesMesures
        .map((e) => e.typeMesure?.libelle ?? 'Article')
        .join(', ');

    final pct = mesure!.pourcentage;
    final barColor = mesure!.isPaid ? AppColors.green : AppColors.primary;

    return GestureDetector(
      onTap: () => Get.to(() => DetailCommandPage(mesure: mesure)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── En-tête ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar initiales
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? Colors.red.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(mesure!.client?.fullName),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: isUrgent ? Colors.red : AppColors.primary,
                      ),
                    ),
                  ),
                  const Gap(12),
                  // Nom + articles
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mesure!.client?.fullName ?? 'Client inconnu',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppColors.primary,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(4),
                        Text(
                          articles,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  // Date + urgent
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (mesure!.dateRetrait != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isUrgent
                                ? Colors.red.withValues(alpha: 0.08)
                                : AppColors.primary.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 10,
                                color:
                                    isUrgent ? Colors.red : AppColors.primary,
                              ),
                              const Gap(4),
                              Text(
                                mesure!.dateRetrait!.toFrenchDateTime,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isUrgent ? Colors.red : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (isUrgent) ...[
                        const Gap(4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_rounded,
                                  color: Colors.white, size: 11),
                              const Gap(3),
                              Text(
                                joursRestants == 0
                                    ? "AUJOURD'HUI"
                                    : joursRestants == 1
                                        ? "DEMAIN"
                                        : "URGENT",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (etats.isNotEmpty) ...[
                        const Gap(4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.end,
                          children:
                              etats.map((e) => _EtatBadge(etat: e)).toList(),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ── Barre de progression ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor:
                            AppColors.ligthGrey.withValues(alpha: 0.8),
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    '${(pct * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: barColor,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),

            // ── Montants + actions ───────────────────────────────────────
            Divider(
                height: 1, color: AppColors.fieldBorder.withValues(alpha: 0.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  // Payé
                  _AmountChip(
                    label: "Payé",
                    value: mesure!.montantPaye.toAmount(unit: "F"),
                    color: AppColors.green,
                  ),
                  const Gap(8),
                  // Total
                  _AmountChip(
                    label: "Total",
                    value: mesure!.montantTotal.toAmount(unit: "F"),
                    color: AppColors.primary,
                  ),
                  const Spacer(),
                  // Actions
                  _IconAction(
                    icon: Icons.print_outlined,
                    color: AppColors.primary,
                    onTap: () {
                      final ctl = Get.put(DetailCommandPageVctl());
                      ctl.printReceipt(mesure!);
                    },
                  ),
                  const Gap(6),
                  _IconAction(
                    icon: Icons.picture_as_pdf_outlined,
                    color: Colors.red,
                    onTap: () {
                      final ctl = Get.put(DetailCommandPageVctl());
                      ctl.exportPdf(mesure!);
                    },
                  ),
                  if (mesure!.resteArgent > 0) ...[
                    const Gap(6),
                    _IconAction(
                      icon: Icons.payments_outlined,
                      color: AppColors.secondary,
                      onTap: () => Get.dialog(PaiementDialog(mesure: mesure!)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _AmountChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: color,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconAction(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _EtatBadge extends StatelessWidget {
  final String etat;
  const _EtatBadge({required this.etat});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final IconData icon;

    switch (etat) {
      case 'Terminée':
        bg = Colors.green.withValues(alpha: 0.1);
        fg = Colors.green.shade700;
        icon = Icons.check_circle_outline;
        break;
      case 'Livrée':
        bg = Colors.blue.withValues(alpha: 0.1);
        fg = Colors.blue.shade700;
        icon = Icons.local_shipping_outlined;
        break;
      default:
        bg = Colors.orange.withValues(alpha: 0.1);
        fg = Colors.orange.shade700;
        icon = Icons.access_time;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const Gap(3),
          Text(etat,
              style: TextStyle(
                  color: fg, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
