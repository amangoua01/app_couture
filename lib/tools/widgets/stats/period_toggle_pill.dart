import 'package:ateliya/tools/widgets/pill_tabs.dart';
import 'package:flutter/material.dart';

/// Sélecteur de période en pilule (jour / mois / année…). Garde son choix
/// en interne et prévient via [onToggle] ; [initialIndex] peut être changé
/// de l'extérieur (le sélecteur suit).
class PeriodTogglePill extends StatefulWidget {
  final List<String> labels;
  final int initialIndex;
  final ValueChanged<int?> onToggle;

  const PeriodTogglePill({
    super.key,
    required this.labels,
    required this.initialIndex,
    required this.onToggle,
  });

  @override
  State<PeriodTogglePill> createState() => _PeriodTogglePillState();
}

class _PeriodTogglePillState extends State<PeriodTogglePill> {
  late int _index = widget.initialIndex;

  @override
  void didUpdateWidget(covariant PeriodTogglePill old) {
    super.didUpdateWidget(old);
    if (old.initialIndex != widget.initialIndex) _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return PillTabs(
      margin: EdgeInsets.zero,
      index: _index,
      tabs: [for (final l in widget.labels) PillTab(l)],
      onChanged: (i) {
        setState(() => _index = i);
        widget.onToggle(i);
      },
    );
  }
}
