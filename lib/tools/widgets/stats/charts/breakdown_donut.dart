import 'package:ateliya/tools/widgets/stats/charts/stat_format.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_card.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BreakdownSlice {
  final String label;
  final num value;
  final Color color;
  const BreakdownSlice(this.label, this.value, this.color);
}

/// Répartition en une barre segmentée suivie d'une légende chiffrée.
/// On touche un segment (ou sa ligne) pour le mettre en avant.
/// (Le nom `BreakdownDonut` est conservé pour les appelants existants.)
class BreakdownDonut extends StatefulWidget {
  final List<BreakdownSlice> slices;
  final String centerLabel;
  final String Function(num) format;

  const BreakdownDonut({
    super.key,
    required this.slices,
    this.centerLabel = 'Total',
    this.format = francs,
  });

  /// Palette sobre, dérivée de l'identité Ateliya.
  static const palette = [
    Color(0xFF0A3A30),
    Color(0xFFD19E49),
    Color(0xFF5C8A78),
    Color(0xFFA9794A),
    Color(0xFF7A7F9A),
    Color(0xFF9DB5A8),
  ];

  @override
  State<BreakdownDonut> createState() => _BreakdownDonutState();
}

class _BreakdownDonutState extends State<BreakdownDonut> {
  int? _touched;

  @override
  Widget build(BuildContext context) {
    final slices = widget.slices.where((s) => s.value > 0).toList();
    final total = slices.fold<num>(0, (a, s) => a + s.value);
    if (total <= 0) {
      return const StatsEmpty(message: 'Aucun revenu à répartir sur cette période');
    }

    final focus =
        _touched != null && _touched! < slices.length ? slices[_touched!] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (focus?.label ?? widget.centerLabel).toUpperCase(),
          style: StatsStyle.caps(),
        ),
        const Gap(4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(widget.format(focus?.value ?? total), style: StatsStyle.number(26)),
            if (focus != null) ...[
              const Gap(10),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  sharePercent(focus.value, total),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: focus.color,
                  ),
                ),
              ),
            ],
          ],
        ),
        const Gap(16),
        SizedBox(
          height: 16,
          child: Row(
            children: [
              for (var i = 0; i < slices.length; i++) ...[
                if (i > 0) const SizedBox(width: 2),
                Expanded(
                  flex: (slices[i].value / total * 1000).round().clamp(1, 1000),
                  child: GestureDetector(
                    onTap: () => setState(() => _touched = _touched == i ? null : i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: _touched == null || _touched == i
                          ? slices[i].color
                          : slices[i].color.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Gap(18),
        for (var i = 0; i < slices.length; i++)
          InkWell(
            onTap: () => setState(() => _touched = _touched == i ? null : i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                border: Border(
                  top: i == 0
                      ? BorderSide.none
                      : const BorderSide(color: StatsStyle.hairline),
                ),
              ),
              child: Row(
                children: [
                  Container(width: 10, height: 10, color: slices[i].color),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      slices[i].label,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight:
                            i == _touched ? FontWeight.w700 : FontWeight.w500,
                        color: StatsStyle.dark,
                      ),
                    ),
                  ),
                  Text(widget.format(slices[i].value), style: StatsStyle.number(13.5)),
                  SizedBox(
                    width: 52,
                    child: Text(
                      sharePercent(slices[i].value, total),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: StatsStyle.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
