import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/shimmer_listtile.dart';
import 'package:ateliya/views/controllers/notifs/notif_list_vctl.dart';
import 'package:ateliya/views/static/notifs/detail_notif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class NotifListPage extends StatelessWidget {
  const NotifListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NotifListVctl(),
      builder: (ctl) {
        final isSelecting = ctl.isSelectionMode;

        return Scaffold(
          appBar: AppBar(
            title: isSelecting
                ? Text(
                    '${ctl.selectedIds.length} sélectionnée(s)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : const Text('Notifications'),
            leading: isSelecting
                ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Annuler la sélection',
                    onPressed: ctl.clearSelection,
                  )
                : null,
            actions: [
              if (isSelecting) ...[
                // Tout sélectionner / tout désélectionner
                TextButton.icon(
                  onPressed: ctl.selectedIds.length == ctl.data.items.length
                      ? ctl.clearSelection
                      : ctl.selectAll,
                  icon: Icon(
                    ctl.selectedIds.length == ctl.data.items.length
                        ? Icons.deselect_rounded
                        : Icons.select_all_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    ctl.selectedIds.length == ctl.data.items.length
                        ? 'Désélect.'
                        : 'Tout',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                // Supprimer la sélection
                IconButton(
                  icon: const Icon(Icons.delete_rounded, color: Colors.white),
                  tooltip: 'Supprimer la sélection',
                  onPressed: () async {
                    final count = ctl.selectedIds.length;
                    final confirm = await CChoiceMessageDialog.show(
                      message:
                          'Supprimer $count notification${count > 1 ? 's' : ''} ?',
                    );
                    if (confirm == true) {
                      await ctl.deleteSelected();
                    }
                  },
                ),
              ] else ...[
                if (ctl.data.items.isNotEmpty)
                  TextButton(
                    onPressed: () => ctl.getList(),
                    child: const Text(
                      'Actualiser',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ],
          ),
          body: ctl.isLoading
              ? ListView.builder(
                  itemCount: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => const ShimmerListtile(),
                )
              : ctl.data.isEmpty
                  ? EmptyDataWidget(
                      message: 'Aucune notification',
                      onRefresh: () => ctl.getList(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ctl.getList(),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Gap(6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        controller: ctl.scrollCtl,
                        itemCount: ctl.data.length,
                        itemBuilder: (context, index) {
                          final notification = ctl.data.items[index];
                          final isUnread = notification.isRead;
                          final id = notification.id;
                          final isSelected = id != null && ctl.isSelected(id);

                          return _NotifItem(
                            notification: notification,
                            isUnread: isUnread,
                            isSelected: isSelected,
                            isSelecting: isSelecting,
                            onTap: () {
                              if (isSelecting) {
                                if (id != null) ctl.toggleSelect(id);
                              } else {
                                if (isUnread && id != null) {
                                  ctl.markAsRead(notification);
                                }
                                Get.to(() => DetailNotifPage(
                                    notification: notification));
                              }
                            },
                            onLongPress: () {
                              if (id != null) ctl.toggleSelect(id);
                            },
                            onDismiss: () async {
                              if (id != null) {
                                final confirm = await Get.dialog<bool>(
                                      AlertDialog(
                                        title: const Text('Supprimer'),
                                        content: const Text(
                                            'Supprimer cette notification ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: false),
                                            child: const Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: true),
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.red),
                                            child: const Text('Supprimer'),
                                          ),
                                        ],
                                      ),
                                    ) ??
                                    false;
                                if (confirm) {
                                  await ctl.deleteNotification(id);
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
          // FAB de suppression flottant quand en mode sélection sur mobile
          floatingActionButton: isSelecting
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    final count = ctl.selectedIds.length;
                    final confirm = await CChoiceMessageDialog.show(
                      message:
                          'Supprimer $count notification${count > 1 ? 's' : ''} ?',
                    );
                    if (confirm == true) await ctl.deleteSelected();
                  },
                  backgroundColor: Colors.red,
                  icon: const Icon(Icons.delete_rounded, color: Colors.white),
                  label: Text(
                    'Supprimer (${ctl.selectedIds.length})',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              : null,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _NotifItem extends StatelessWidget {
  final dynamic notification;
  final bool isUnread;
  final bool isSelected;
  final bool isSelecting;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Future<void> Function() onDismiss;

  const _NotifItem({
    required this.notification,
    required this.isUnread,
    required this.isSelected,
    required this.isSelecting,
    required this.onTap,
    required this.onLongPress,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.08)
            : isUnread
                ? AppColors.primary.withValues(alpha: 0.04)
                : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.4)
              : Colors.grey.shade100,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Dismissible(
        key: Key('notif_${notification.id}'),
        direction:
            isSelecting ? DismissDirection.none : DismissDirection.endToStart,
        confirmDismiss: (_) async {
          await onDismiss();
          return false; // on gère nous-même la suppression
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading : checkbox en mode sélection, avatar sinon
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: isSelecting
                        ? Padding(
                            key: const ValueKey('check'),
                            padding: const EdgeInsets.only(right: 10, top: 4),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check_rounded,
                                      size: 14, color: Colors.white)
                                  : null,
                            ),
                          )
                        : Padding(
                            key: const ValueKey('avatar'),
                            padding: const EdgeInsets.only(right: 12),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isUnread
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : Colors.grey[100],
                                  child: SvgPicture.asset(
                                    'assets/images/svg/notif.svg',
                                    width: 22,
                                    colorFilter: ColorFilter.mode(
                                      isUnread
                                          ? AppColors.primary
                                          : Colors.grey[400]!,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                if (isUnread)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 11,
                                      height: 11,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                  // Contenu
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.titre ?? 'Notification',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isUnread ? FontWeight.bold : FontWeight.w500,
                            color: isUnread ? Colors.black87 : Colors.grey[700],
                          ),
                        ),
                        const Gap(3),
                        Text(
                          notification.libelle ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: isUnread ? Colors.black54 : Colors.grey[500],
                          ),
                        ),
                        const Gap(6),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 11, color: Colors.grey[400]),
                            const Gap(3),
                            Text(
                              notification.dateFormatted,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Trailing
                  if (!isSelecting)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isUnread)
                          const Icon(Icons.circle,
                              size: 8, color: AppColors.primary),
                        const Gap(4),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 13, color: Colors.grey[300]),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
