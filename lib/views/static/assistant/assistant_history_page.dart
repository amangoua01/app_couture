import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/data/models/assistant/assistant_conversation.dart';
import 'package:ateliya/views/controllers/assistant/assistant_history_page_vctl.dart';
import 'package:ateliya/views/static/assistant/assistant_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Liste des conversations passées. Renvoie l'identifiant de celle choisie.
class AssistantHistoryPage extends StatelessWidget {
  /// Appelé quand une conversation est supprimée (pour réinitialiser le chat si c'était la sienne).
  final void Function(int id)? onDeleted;
  const AssistantHistoryPage({super.key, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssistantHistoryPageVctl>(
      init: AssistantHistoryPageVctl(onDeleted: onDeleted),
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
                              "Modifiée le ${formatDateTime(c.misAJourLe!)}",
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: "Options",
                      icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMuted),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      onSelected: (v) {
                        if (v == 'rename') _rename(ctl, c);
                        if (v == 'delete') _confirmDelete(ctl, c);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'rename',
                          child: Row(children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 10),
                            Text("Renommer"),
                          ]),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger),
                            SizedBox(width: 10),
                            Text("Supprimer", style: TextStyle(color: AppColors.danger)),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _rename(AssistantHistoryPageVctl ctl, AssistantConversation c) async {
    final input = TextEditingController(text: c.titre);
    final titre = await Get.dialog<String>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Renommer la conversation", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: TextField(
          controller: input,
          autofocus: true,
          maxLength: 150,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: "Nom de la conversation"),
          onSubmitted: (v) => Get.back(result: v),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Annuler")),
          TextButton(
            onPressed: () => Get.back(result: input.text),
            child: const Text("Enregistrer", style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    // Pas de dispose() ici : le champ est encore affiché pendant l'animation de fermeture.
    if (titre == null || titre.trim().isEmpty || titre.trim() == c.titre) return;
    await ctl.rename(c, titre);
  }

  Future<void> _confirmDelete(AssistantHistoryPageVctl ctl, AssistantConversation c) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Supprimer la conversation ?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: Text(
          "« ${c.titre} » et tous ses messages seront supprimés. Les tokens déjà utilisés ne sont pas remboursés.",
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("Annuler")),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Supprimer", style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok == true) await ctl.remove(c);
  }
}
