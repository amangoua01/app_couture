import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DonutSlice {
  final String label;
  final num value;
  final Color color;
  const DonutSlice({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Donut + légende générique — réutilisé pour toute section "Répartition
/// par X" (stock, revenus, ...) avec le même agencement visuel.
class RepartitionDonut extends StatelessWidget {
  final String title;
  final List<DonutSlice> slices;
  const RepartitionDonut({
    super.key,
    required this.title,
    required this.slices,
  });

  static const palette = [
    AppColors.primary,
    AppColors.secondary,
    Color(0xFF6FA88A),
    Color(0xFFB08968),
    Color(0xFF8E7CC3),
  ];

  @override
  Widget build(BuildContext context) {
    final total = slices.fold<num>(0, (sum, s) => sum + s.value);
    if (total <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 36,
                    sections: [
                      for (final s in slices)
                        PieChartSectionData(
                          value: s.value.toDouble(),
                          color: s.color,
                          radius: 26,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final s in slices)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: s.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: Text(
                                s.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ),
                            Text(
                              "${((s.value / total) * 100).round()}%",
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
