import 'package:ateliya/data/models/transaction_response.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/notif_badge_icon.dart';
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
    return GetBuilder(
      init: TransactionPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA), // Fond gris clair moderne
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text("Transactions"),
            actions: [
              IconButton(
                onPressed: () => _showDatePicker(context),
                icon: const Icon(Icons.filter_list_rounded),
              ),
              NotifBadgeIcon(
                count: ctl.nbUnreadNotifs,
                onRefresh: () => ctl.loadUnreadCount(),
              ),
            ],
          ),
          body: PlaceholderWidget(
            condition: !ctl.isLoading,
            placeholder: const Center(child: CircularProgressIndicator()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                // Date Selector Pill
                Center(
                  child: InkWell(
                    onTap: () => _showDatePicker(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ]),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 16, color: Colors.grey[700]),
                          const Gap(10),
                          Text(
                            ctl.formattedDate,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const Gap(6),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              size: 18, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
                ),

                if (ctl.data != null) ...[
                  const Gap(24),
                  // Solde Total
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Text("Solde total",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                        const Gap(5),
                        Text(
                          ctl.data!.summary.total.toAmount(unit: "F"),
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: ctl.data!.summary.total >= 0
                                  ? Colors.black
                                  : Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  // Cards Revenus / Dépenses
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildSummaryCard(
                          title: "Revenus",
                          amount: ctl.data!.summary.revenus,
                          color: Colors.green,
                          icon: Icons.arrow_downward_rounded,
                        )),
                        const Gap(16),
                        Expanded(
                            child: _buildSummaryCard(
                          title: "Dépenses",
                          amount: ctl.data!.summary.depenses,
                          color: Colors.red,
                          icon: Icons.arrow_upward_rounded,
                        )),
                      ],
                    ),
                  ),
                  const Gap(24),
                ],

                // Liste Transactions
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(30)),
                      child: ctl.data == null
                          ? EmptyDataWidget(
                              onRefresh: ctl.fetchData,
                            )
                          : ctl.data!.transactions.isEmpty
                              ? EmptyDataWidget(
                                  message:
                                      "Aucune transaction pour cette période",
                                  onRefresh: ctl.fetchData,
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(20),
                                  itemCount: ctl.data!.transactions.length,
                                  itemBuilder: (context, index) {
                                    // Ajouter un titre jour si nécessaire (optionnel)
                                    return _buildTransactionItem(
                                        ctl.data!.transactions[index]);
                                  },
                                ),
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

  Widget _buildSummaryCard(
      {required String title,
      required double amount,
      required Color color,
      required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 16),
              ),
              const Gap(10),
              Text(title,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const Gap(12),
          Text(
            amount.toAmount(unit: "F"),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(TransactionItem item) {
    Color iconColor = item.isRevenu ? Colors.green : Colors.red;
    IconData iconData = item.isRevenu
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    // Custom Icon based on type if needed
    if (item.type.toLowerCase().contains("achat")) {
      iconData = Icons.shopping_bag_outlined;
    } else if (item.type.toLowerCase().contains("facture")) {
      iconData = Icons.receipt_long_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(iconData, color: iconColor, size: 22),
          ),
          const Gap(16),
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
                const Gap(4),
                Text(
                  item.description,
                  style: TextStyle(
                      color: Colors.grey[500], fontSize: 12, height: 1.2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                Text(
                  "${item.date.split('T').first} • ${item.heure}",
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${item.isRevenu ? "+" : "-"} ${item.montant.toAmount(unit: "")}",
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
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    item.moyenPaiement!,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500),
                  ),
                )
              ]
            ],
          )
        ],
      ),
    );
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
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filtrer par date",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        ctl.toggleMode();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20)),
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
              const Gap(10),
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
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0),
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
