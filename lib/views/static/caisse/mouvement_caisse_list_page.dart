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
          backgroundColor: const Color(0xFFF8FAF9),
          appBar: AppBar(
            title: const Text("Mouvements de caisse"),
          ),
          body: Column(
            children: [
              // ── Header Période de filtrage (Uniformisé) ───────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Période de filtrage",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color:
                                    AppColors.primary.withValues(alpha: 0.45),
                                letterSpacing: 0.1,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              "${DateFormat('dd/MM/yyyy').format(ctl.dateRange.start)} - ${DateFormat('dd/MM/yyyy').format(ctl.dateRange.end)}",
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _showDatePicker(context, ctl),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 16),
                        label: const Text(
                          "Modifier",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
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
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
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
    final color = isEntree ? Colors.green.shade600 : Colors.red.shade600;
    final icon = isEntree ? Icons.north_east_rounded : Icons.south_west_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Indicateur d'entrée/sortie d'argent chic
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Gap(14),

            // Détails du mouvement
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.reference ?? "Mouvement",
                    style: const TextStyle(
                      color: Color(0xFF0F231F),
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                      letterSpacing: -0.15,
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppColors.primary.withValues(alpha: 0.35),
                      ),
                      const Gap(4),
                      if (item.createdAt != null)
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm')
                              .format(DateTime.parse(item.createdAt!)),
                          style: TextStyle(
                            color: AppColors.primary.withValues(alpha: 0.45),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  if (item.description != null &&
                      item.description!.isNotEmpty) ...[
                    const Gap(6),
                    Text(
                      item.description!,
                      style: TextStyle(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        fontSize: 12,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Gap(12),

            // Montant et libellé
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${isEntree ? '+' : '-'} ${item.montant?.toAmount(unit: 'F') ?? '0 F'}",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: color,
                    letterSpacing: -0.2,
                  ),
                ),
                const Gap(4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.sensLibelle ?? "",
                    style: TextStyle(
                      fontSize: 9.5,
                      color: AppColors.primary.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
