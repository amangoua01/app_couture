import 'package:ateliya/data/models/transaction_response.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/c_card.dart';
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
                // ── Header Wallet avec CCard ───────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: CCard(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ctl.data != null) ...[
                            // Ligne 1 : Titre "SOLDE CUMULÉ" + Sélecteur de date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "SOLDE CUMULÉ",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _showDatePicker(context),
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.calendar_today_rounded,
                                            size: 11,
                                            color: AppColors.secondary),
                                        const Gap(6),
                                        Text(
                                          ctl.formattedDate,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                        const Gap(4),
                                        Icon(Icons.keyboard_arrow_down_rounded,
                                            size: 13,
                                            color: Colors.white
                                                .withValues(alpha: 0.8)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(4),

                            // Ligne 2 : Montant du solde
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

                            // Cards Revenus / Dépenses
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
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAF9),
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

  void _showDatePicker(BuildContext context) {
    CBottomSheet.show(
      child: GetBuilder<TransactionPageVctl>(
        builder: (ctl) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrer par date",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary),
                    ),
                    InkWell(
                      onTap: ctl.toggleMode,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ctl.isMonthMode ? "Vue Mois" : "Vue Jour",
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
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
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                  dayTextStyle: const TextStyle(color: AppColors.primary),
                  yearTextStyle: const TextStyle(color: AppColors.primary),
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
                            borderRadius: BorderRadius.circular(16)),
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

// ── Cards résumé vitrées WAO ─────────────────────────────────────────────────

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

// ── Item de transaction WAO ───────────────────────────────────────────────────

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
          // Icône dans badge circulaire lumineux plus compact
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

          // Infos
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

          // Montant + moyen de paiement
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
