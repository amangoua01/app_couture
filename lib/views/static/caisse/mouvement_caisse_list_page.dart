import 'package:ateliya/data/models/mouvement_caisse.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/views/controllers/caisse/mouvement_caisse_list_vctl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MouvementCaisseListPage extends StatelessWidget {
  const MouvementCaisseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MouvementCaisseListVctl>(
      init: MouvementCaisseListVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text("Mouvements de caisse"),
          ),
          body: Column(
            children: [
              // ── Header avec sélecteur de date ──────────────────────────
              Container(
                width: double.infinity,
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  children: [
                    const Text(
                      "Historique des mouvements de caisse",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(12),
                    InkWell(
                      onTap: () => _showDatePicker(context, ctl),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
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
                              "${DateFormat('dd/MM/yyyy').format(ctl.dateRange.start)} - ${DateFormat('dd/MM/yyyy').format(ctl.dateRange.end)}",
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
                  ],
                ),
              ),

              // ── Liste des mouvements ──────────────────────────────────
              Expanded(
                child: PlaceholderWidget(
                  condition: !ctl.isLoading,
                  placeholder: const Center(child: CircularProgressIndicator()),
                  child: ctl.data.isEmpty
                      ? EmptyDataWidget(
                          message: "Aucun mouvement trouvé",
                          onRefresh: ctl.fetchData,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: ctl.data.items.length,
                          itemBuilder: (context, index) {
                            final item = ctl.data.items[index];
                            return _MouvementTile(item: item);
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context, MouvementCaisseListVctl ctl) {
    CBottomSheet.show(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                "Filtrer par date",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            const Gap(8),
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
                selectedDayHighlightColor: AppColors.primary,
              ),
              value: [ctl.dateRange.start, ctl.dateRange.end],
              onValueChanged: (dates) {
                if (dates.length >= 2) {
                  ctl.updateDateRange(
                    DateTimeRange(
                      start: dates[0],
                      end: dates[1],
                    ),
                  );
                  Get.back();
                }
              },
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class _MouvementTile extends StatelessWidget {
  final MouvementCaisse item;

  const _MouvementTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isEntree = item.sens == 1;
    final color = isEntree ? Colors.green : Colors.red;
    final icon =
        isEntree ? Icons.add_circle_outline : Icons.remove_circle_outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.reference ?? "Mouvement",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (item.createdAt != null) ...[
                  const Gap(4),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(DateTime.parse(item.createdAt!)),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
                  const Gap(4),
                  Text(
                    item.description!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isEntree ? '+' : '-'} ${item.montant?.toAmount(unit: 'F') ?? '0 F'}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              const Gap(4),
              Text(
                item.sensLibelle ?? "",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
