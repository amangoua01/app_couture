import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Bloc thématique d'un écran de statistiques : un filet, un titre précédé
/// d'une icône, puis le contenu. Pas de carte, pas d'ombre.
class StatsCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final Widget child;

  const StatsCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 18),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: StatsStyle.hairline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: StatsStyle.ink),
                const Gap(10),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: StatsStyle.dark,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null) ...[
            const Gap(3),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: StatsStyle.muted),
            ),
          ],
          const Gap(16),
          child,
        ],
      ),
    );
  }
}

/// État vide d'un graphique : un cadre fin et une phrase, sans pictogramme.
class StatsEmpty extends StatelessWidget {
  final String message;
  final double height;

  const StatsEmpty({
    super.key,
    this.message = "Pas encore d'activité sur cette période",
    this.icon,
    this.height = 110,
  });

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(color: StatsStyle.hairline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12.5,
          height: 1.4,
          color: StatsStyle.muted,
        ),
      ),
    );
  }
}
