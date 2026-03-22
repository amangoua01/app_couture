import 'package:ateliya/data/models/transaction_response.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/views/controllers/home/transaction_page_vctl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionPageVctl>(
      init: TransactionPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: MainAppBar(
            enterpriseTitle: ctl.getEntite().value.libelle.value,
            notifCount: ctl.nbUnreadNotifs,
            onSelectionChanged: () => ctl.fetchData(),
            onNotifRefresh: () => ctl.loadUnreadCount(),
          ),
          body: PlaceholderWidget(
            condition: !ctl.isLoading,
            placeholder: const Center(child: CircularProgressIndicator()),
            child: Column(
              children: [
                // ── Header avec solde + résumé ──────────────────────────
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        Color.fromRGBO(56, 152, 160, 1)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
                  child: Column(
                    children: [
                      // Sélecteur de date stylisé
                      InkWell(
                        onTap: () => _showDatePicker(context),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 14, color: Colors.white),
                              const Gap(8),
                              Text(
                                ctl.formattedDate,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(6),
                              const Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 16, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      const Gap(18),

                      // Solde total
                      if (ctl.data != null) ...[
                        Text(
                          "Solde total",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          ctl.data!.summary.total.toAmount(unit: "F"),
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: ctl.data!.summary.total >= 0
                                ? Colors.white
                                : Colors.red[200],
                            letterSpacing: -1,
                          ),
                        ),
                        const Gap(22),

                        // Cards Revenus / Dépenses
                        Row(
                          children: [
                            Expanded(
                              child: _SummaryCard(
                                title: "Revenus",
                                amount: ctl.data!.summary.revenus,
                                color: Colors.green,
                                icon: Icons.arrow_downward_rounded,
                              ),
                            ),
                            const Gap(14),
                            Expanded(
                              child: _SummaryCard(
                                title: "Dépenses",
                                amount: ctl.data!.summary.depenses,
                                color: Colors.red,
                                icon: Icons.arrow_upward_rounded,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const Gap(10),
                        Text(
                          "Sélectionnez une période",
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14),
                        ),
                        const Gap(10),
                      ],
                    ],
                  ),
                ),

                // ── Liste Transactions ──────────────────────────────────
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: ctl.data == null
                        ? EmptyDataWidget(onRefresh: ctl.fetchData)
                        : ctl.data!.transactions.isEmpty
                            ? EmptyDataWidget(
                                message:
                                    "Aucune transaction pour cette période",
                                onRefresh: ctl.fetchData,
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey[500],
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                      _TransactionTile(item: item),
                                      const Gap(10),
                                    ],
                                  );
                                },
                              ),
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
    if (parts.length < 3) return isoDate;
    final dt =
        DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (dt == today) return "Aujourd'hui";
    if (dt == yesterday) return "Hier";
    const months = [
      '',
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return "${dt.day} ${months[dt.month]} ${dt.year}";
  }

  void _showDatePicker(BuildContext context) {
    CBottomSheet.show(
      child: GetBuilder<TransactionPageVctl>(
        builder: (ctl) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrer par date",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: ctl.toggleMode,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ctl.isMonthMode ? "Vue Mois" : "Vue Jour",
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              const Gap(8),
              CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.single,
                  selectedDayHighlightColor: AppColors.primary,
                  centerAlignModePicker: true,
                  controlsHeight: 50,
                  controlsTextStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  dayTextStyle: const TextStyle(color: Colors.black),
                  yearTextStyle: const TextStyle(color: Colors.black),
                ),
                value: ctl.selectedDay != null ? [ctl.selectedDay!] : [],
                onValueChanged: (dates) {
                  if (dates.isNotEmpty) {
                    ctl.onDateSelected(dates.first, dates.first);
                    Get.back();
                  }
                },
                onDisplayedMonthChanged: ctl.onPageChanged,
              ),
              if (ctl.isMonthMode)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Voir tout le mois",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Cards résumé ─────────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: color == Colors.green ? color : Colors.red[300],
                size: 16),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                ),
                const Gap(2),
                Text(
                  amount.toAmount(unit: "F"),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
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
    Color iconColor = item.isRevenu ? Colors.green : Colors.red;
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const Gap(14),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.type,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87),
                ),
                if (item.description.isNotEmpty) ...[
                  const Gap(2),
                  Text(
                    item.description,
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 12, height: 1.3),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const Gap(4),
                Text(
                  item.heure,
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ),

          // Montant + moyen de paiement
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${item.isRevenu ? "+" : "−"} ${item.montant.toAmount(unit: "F")}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: iconColor,
                ),
              ),
              if (item.moyenPaiement != null) ...[
                const Gap(4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.moyenPaiement!,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600),
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
