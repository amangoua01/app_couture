import 'package:ateliya/data/models/transaction_response.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/c_card.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/views/controllers/home/transaction_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionPageVctl>(
      init: TransactionPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAF9),
          appBar: MainAppBar(
            enterpriseTitle: ctl.getEntite().value.libelle.value,
            notifCount: ctl.nbUnreadNotifs,
            onSelectionChanged: () => ctl.fetchData(),
            onNotifRefresh: () => ctl.loadUnreadCount(),
          ),
          body: PlaceholderWidget(
            condition: !ctl.isLoading,
            placeholder: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            ),
            child: Column(
              children: [
                // ── Filtres ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ToggleSwitch(
                            inactiveBgColor: AppColors.secondary,
                            activeBgColor: const [AppColors.primary],
                            activeFgColor: Colors.white,
                            inactiveFgColor:
                                Colors.white.withValues(alpha: 0.7),
                            minWidth: 96.0,
                            cornerRadius: 14,
                            initialLabelIndex:
                                ctl.mode == TransactionFilterMode.jour ? 0 : 1,
                            labels: const ["Jour", "Mois"],
                            onToggle: (index) {
                              if (index == 0) {
                                ctl.onDaySelected(ctl.focusedDay);
                              } else {
                                ctl.selectMonth();
                              }
                            },
                          ),
                          const Gap(10),
                          IconButton(
                            onPressed: () => ctl.pickDateRange(context),
                            icon: const Icon(
                              Icons.calendar_month,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      // Affiche la date sélectionnée
                      GestureDetector(
                        onTap: () => ctl.pickDateRange(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month,
                                  color: AppColors.primary, size: 14),
                              const Gap(8),
                              Text(
                                ctl.formattedDate,
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(8),

                // ── Header Wallet ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  child: CCard(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ctl.data != null) ...[
                            Text(
                              "SOLDE CUMULÉ",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              ctl.data!.summary.total.toAmount(unit: "F"),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: ctl.data!.summary.total >= 0
                                    ? Colors.white
                                    : const Color(0xFFC76D6D),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Gap(14),
                            Row(
                              children: [
                                Expanded(
                                  child: _SummaryCard(
                                    title: "Revenus",
                                    amount: ctl.data!.summary.revenus,
                                    color: AppColors.green,
                                    icon: Icons.arrow_downward_rounded,
                                  ),
                                ),
                                const Gap(8),
                                Expanded(
                                  child: _SummaryCard(
                                    title: "Dépenses",
                                    amount: ctl.data!.summary.depenses,
                                    color: const Color(0xFFC76D6D),
                                    icon: Icons.arrow_upward_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            const Gap(8),
                            Text(
                              "Sélectionnez une période",
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12),
                            ),
                            const Gap(8),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Liste Transactions ─────────────────────────────
                Expanded(
                  child: ctl.data == null
                      ? EmptyDataWidget(onRefresh: ctl.fetchData)
                      : ctl.data!.transactions.isEmpty
                          ? EmptyDataWidget(
                              message: "Aucune transaction pour cette période",
                              onRefresh: ctl.fetchData,
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 12, 16, 28),
                              itemCount: ctl.data!.transactions.length,
                              itemBuilder: (context, index) {
                                final item = ctl.data!.transactions[index];
                                final prev = index > 0
                                    ? ctl.data!.transactions[index - 1]
                                    : null;
                                final showDate = prev == null ||
                                    item.date.split('T').first !=
                                        prev.date.split('T').first;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (showDate) ...[
                                      if (index != 0) const Gap(8),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 4),
                                        child: Text(
                                          _formatDateLabel(
                                              item.date.split('T').first),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primary
                                                .withValues(alpha: 0.4),
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                    ],
                                    _TransactionTile(item: item),
                                    const Gap(8),
                                  ],
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDateLabel(String isoDate) {
    final parts = isoDate.split('-');
    if (parts.length < 3) return isoDate.toUpperCase();
    final dt =
        DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (dt == today) return "AUJOURD'HUI";
    if (dt == yesterday) return "HIER";
    const months = [
      '',
      'JANVIER',
      'FÉVRIER',
      'MARS',
      'AVRIL',
      'MAI',
      'JUIN',
      'JUILLET',
      'AOÛT',
      'SEPTEMBRE',
      'OCTOBRE',
      'NOVEMBRE',
      'DÉCEMBRE'
    ];
    return "${dt.day} ${months[dt.month]} ${dt.year}";
  }
}

// ── Cards résumé ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
                const Gap(2),
                Text(
                  amount.toAmount(unit: "F"),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: -0.1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Item de transaction ───────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final TransactionItem item;

  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    Color iconColor = item.isRevenu ? AppColors.green : const Color(0xFFC76D6D);
    IconData iconData = item.isRevenu
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    if (item.type.toLowerCase().contains("achat")) {
      iconData = Icons.shopping_bag_outlined;
    } else if (item.type.toLowerCase().contains("facture")) {
      iconData = Icons.receipt_long_rounded;
    } else if (item.type.toLowerCase().contains("depense") ||
        item.type.toLowerCase().contains("dépense")) {
      iconData = Icons.money_off_rounded;
    } else if (item.type.toLowerCase().contains("vente")) {
      iconData = Icons.storefront_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: iconColor, size: 18),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.type,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: AppColors.primary,
                      letterSpacing: -0.1),
                ),
                if (item.description.isNotEmpty) ...[
                  const Gap(2),
                  Text(
                    item.description,
                    style: TextStyle(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        fontSize: 11,
                        height: 1.2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const Gap(3),
                Text(
                  item.heure,
                  style: TextStyle(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${item.isRevenu ? "+" : "−"} ${item.montant.toAmount(unit: "F")}",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: iconColor,
                  letterSpacing: -0.2,
                ),
              ),
              if (item.moyenPaiement != null) ...[
                const Gap(4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.moyenPaiement!,
                    style: TextStyle(
                        fontSize: 9,
                        color: AppColors.primary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
