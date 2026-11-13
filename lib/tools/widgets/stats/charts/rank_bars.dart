import 'package:ateliya/tools/widgets/stats/charts/stats_card.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RankItem {
  final String label;
  final num value;
  final String valueText;
  final String? caption;
  const RankItem({
    required this.label,
    required this.value,
    required this.valueText,
    this.caption,
  });
}

/// Classement : numéro, libellé, valeur, et une barre fine qui se remplit.
class RankBars extends StatelessWidget {
  final List<RankItem> items;
  final Color color;
  final String emptyMessage;

  const RankBars({
    super.key,
    required this.items,
    this.color = StatsStyle.ink,
    this.emptyMessage = 'Aucune donnée sur cette période',
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty || items.every((i) => i.value <= 0)) {
      return StatsEmpty(message: emptyMessage);
    }
    final maxValue = items.fold<num>(0, (m, i) => i.value > m ? i.value : m);

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 26,
                  child: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: i == 0 ? StatsStyle.gold : StatsStyle.muted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              items[i].label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: StatsStyle.dark,
                              ),
                            ),
                          ),
                          const Gap(8),
                          Text(
                            items[i].valueText,
                            style: StatsStyle.number(13.5),
                          ),
                        ],
                      ),
                      const Gap(7),
                      TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: maxValue <= 0
                              ? 0
                              : (items[i].value / maxValue).toDouble(),
                        ),
                        duration: Duration(milliseconds: 650 + i * 100),
                        curve: Curves.easeOutCubic,
                        builder: (_, v, __) => LayoutBuilder(
                          builder: (_, box) => Stack(
                            children: [
                              Container(height: 4, color: StatsStyle.hairline),
                              Container(
                                height: 4,
                                width: box.maxWidth * v,
                                color: i == 0 ? StatsStyle.gold : color,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (items[i].caption != null) ...[
                        const Gap(5),
                        Text(
                          items[i].caption!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: StatsStyle.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
