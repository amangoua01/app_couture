import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/widgets/setting_tile.dart';
import 'package:ateliya/views/static/home/sub_pages/setting/setting_menu.dart';
import 'package:flutter/material.dart';

/// Carte blanche regroupant plusieurs lignes de réglages.
///
/// Le séparateur est déduit de la position réelle de chaque ligne : une entrée
/// masquée ne laisse donc jamais de trait en bas de carte.
class SettingsGroup extends StatelessWidget {
  final List<SettingEntry> entries;

  const SettingsGroup({required this.entries, super.key});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: CardStyle.decoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            SettingTile(
              title: entries[i].title,
              subtitle: entries[i].subtitle,
              icon: entries[i].icon,
              color: entries[i].color,
              showDivider: i < entries.length - 1,
              onTap: entries[i].onTap,
            ),
        ],
      ),
    );
  }
}
