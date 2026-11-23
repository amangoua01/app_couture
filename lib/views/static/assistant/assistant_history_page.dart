import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/assistant/assistant_history_page_vctl.dart';
import 'package:ateliya/views/static/assistant/assistant_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Liste des conversations passées. Renvoie l'identifiant de celle choisie.
class AssistantHistoryPage extends StatelessWidget {
  const AssistantHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssistantHistoryPageVctl>(
      init: AssistantHistoryPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
            scrolledUnderElevation: 0,
            title: const Text("Historique", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          body: _body(ctl),
        );
      },
    );
  }

  Widget _body(AssistantHistoryPageVctl ctl) {
    if (ctl.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (ctl.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ctl.error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 12),
              TextButton(onPressed: ctl.load, child: const Text("Réessayer")),
            ],
          ),
        ),
      );
    }
    if (ctl.conversations.isEmpty) {
      return const Center(
        child: Text("Aucune conversation pour le moment.", style: TextStyle(color: AppColors.textMuted)),
      );
    }
    return RefreshIndicator(
      onRefresh: ctl.load,
      child: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: ctl.conversations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final c = ctl.conversations[i];
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Get.back(result: c.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.titre,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                          ),
                          if (c.misAJourLe != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              formatDate(c.misAJourLe!),
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
