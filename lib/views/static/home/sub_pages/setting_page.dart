import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/settings/quick_profile_card.dart';
import 'package:ateliya/tools/widgets/settings/setting_section_label.dart';
import 'package:ateliya/tools/widgets/settings/settings_group.dart';
import 'package:ateliya/tools/widgets/settings/settings_search_field.dart';
import 'package:ateliya/views/controllers/home/setting_page_vctl.dart';
import 'package:ateliya/views/static/auth/profil_page.dart';
import 'package:ateliya/views/static/home/sub_pages/setting/setting_menu.dart';
import 'package:ateliya/views/static/home/sub_pages/setting/unified_profile_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SettingPageVctl(),
      builder: (ctl) {
        final query = ctl.searchQuery;
        final sections = buildSettingSections(ctl);
        final isSearching = query.trim().isNotEmpty;

        // Pendant une recherche, l'en-tête de profil laisse la place aux résultats.
        final visibleSections =
            sections
                .map((s) => (section: s, entries: s.visibleEntries(query)))
                .where((e) => e.entries.isNotEmpty)
                .toList();

        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: MainAppBar(
            enterpriseTitle: ctl.getEntite().value.libelle.value,
            notifCount: ctl.nbUnreadNotifs,
            onSelectionChanged: () => ctl.update(),
            onNotifRefresh: () => ctl.loadUnreadCount(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSearching) ...[
                  UnifiedProfileHeader(ctl: ctl),
                  const Gap(16),
                  QuickProfileCard(
                    name: ctl.user.fullName,
                    onTap:
                        () => Get.to(() => const ProfilPage())?.then((e) {
                          if (e is User) {
                            ctl.user = e;
                            ctl.update();
                          }
                        }),
                  ),
                  const Gap(20),
                ],
                SettingsSearchField(
                  controller: ctl.searchCtl,
                  onChanged: ctl.onSearchChanged,
                ),
                const Gap(24),
                if (visibleSections.isEmpty)
                  const _NoSettingResult()
                else
                  for (final item in visibleSections) ...[
                    if (item.section.label != null) ...[
                      SettingSectionLabel(item.section.label!),
                      const Gap(8),
                    ],
                    SettingsGroup(entries: item.entries),
                    const Gap(24),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NoSettingResult extends StatelessWidget {
  const _NoSettingResult();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 42,
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
          const Gap(12),
          const Text(
            "Aucun réglage ne correspond",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
          const Gap(4),
          const Text(
            "Essayez un autre mot-clé.",
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
