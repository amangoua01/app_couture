import 'package:ateliya/tools/widgets/stats/charts/animated_count.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Indicateur : icône, chiffre qui compte jusqu'à sa valeur, libellé.
class KpiTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final num value;
  final String Function(num) format;
  final String? caption;
  final Color color;

  const KpiTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.format,
    this.caption,
    this.color = StatsStyle.ink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 16, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const Gap(12),
          AnimatedCount(
            value: value,
            format: format,
            style: StatsStyle.number(26),
          ),
          const Gap(6),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: StatsStyle.muted),
          ),
          if (caption != null) ...[
            const Gap(3),
            Text(
              caption!,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Grille à deux colonnes, séparée par des filets comme un tableau.
class KpiGrid extends StatelessWidget {
  final List<Widget> tiles;
  const KpiGrid({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      final last = i + 2 >= tiles.length;
      rows.add(
        IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: const BorderSide(color: StatsStyle.hairline),
                bottom: last
                    ? const BorderSide(color: StatsStyle.hairline)
                    : BorderSide.none,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: tiles[i]),
                Container(width: 1, color: StatsStyle.hairline),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: i + 1 < tiles.length ? tiles[i + 1] : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

/// Jauge horizontale d'un pourcentage (ex. taux de recouvrement).
class PercentGauge extends StatelessWidget {
  final double percent; // 0..100
  final Color color;

  const PercentGauge({
    super.key,
    required this.percent,
    this.color = StatsStyle.ink,
  });

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0, 100) / 100;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: p.toDouble()),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${(v * 100).round()} %', style: StatsStyle.number(30)),
          const Gap(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: v,
              minHeight: 8,
              backgroundColor: StatsStyle.hairline,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
