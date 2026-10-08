import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/setting_tile.dart';
import 'package:ateliya/views/static/home/sub_pages/setting/setting_menu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Carte blanche regroupant plusieurs lignes de réglages.
///
/// Le séparateur est déduit de la position réelle de chaque ligne : une entrée
/// masquée ne laisse donc jamais de trait en bas de carte.
///
/// Deux entrées consécutives marquées [SettingEntry.sideBySide] sont présentées
/// côte à côte plutôt qu'empilées — c'est le cas des deux boutiques
/// d'applications, qui se comparent d'un regard.
class SettingsGroup extends StatelessWidget {
  final List<SettingEntry> entries;

  const SettingsGroup({required this.entries, super.key});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final lignes = <Widget>[];
    var i = 0;
    while (i < entries.length) {
      final appariable = entries[i].sideBySide &&
          i + 1 < entries.length &&
          entries[i + 1].sideBySide;

      if (appariable) {
        lignes.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Expanded(child: _PaveEntree(entry: entries[i])),
                const Gap(10),
                Expanded(child: _PaveEntree(entry: entries[i + 1])),
              ],
            ),
          ),
        );
        if (i + 2 < entries.length) lignes.add(const _Separateur(indent: 16));
        i += 2;
      } else {
        lignes.add(
          SettingTile(
            title: entries[i].title,
            subtitle: entries[i].subtitle,
            icon: entries[i].icon,
            iconWidget: entries[i].iconWidget,
            color: entries[i].color,
            showDivider: i < entries.length - 1,
            onTap: entries[i].onTap,
          ),
        );
        i++;
      }
    }

    return Container(
      decoration: CardStyle.decoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(children: lignes),
    );
  }
}

class _Separateur extends StatelessWidget {
  final double indent;
  const _Separateur({required this.indent});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: indent,
      color: Colors.grey[150],
    );
  }
}

/// Entrée en demi-largeur : le visuel au-dessus du libellé, pour tenir dans la
/// largeur réduite sans tronquer le texte.
class _PaveEntree extends StatelessWidget {
  final SettingEntry entry;
  const _PaveEntree({required this.entry});

  @override
  Widget build(BuildContext context) {
    final accent = entry.color;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: entry.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.14)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: Center(
                  child: entry.iconWidget ??
                      Icon(entry.icon, color: accent, size: 22),
                ),
              ),
              const Gap(9),
              Text(
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const Gap(2),
              Text(
                "Télécharger",
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
