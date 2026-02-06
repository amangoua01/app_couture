import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: const Text("Notifications"),
            actions: [
              if (ctl.data.items.isNotEmpty)
                TextButton(
                  onPressed: () => ctl.getList(),
                  child: const Text(
                    "Actualiser",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                      message: "Aucune notification",
                      onRefresh: () => ctl.getList(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ctl.getList(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        controller: ctl.scrollCtl,
                        itemCount: ctl.data.length,
                        itemBuilder: (context, index) {
                          final notification = ctl.data.items[index];
                          final isUnread = notification.etat == false;

                          return Dismissible(
                            key: Key(notification.id.toString()),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await Get.dialog<bool>(
                                    AlertDialog(
                                      title: const Text("Supprimer"),
                                      content: const Text(
                                          "Voulez-vous vraiment supprimer cette notification ?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Get.back(result: false),
                                          child: const Text("Annuler"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.red),
                                          child: const Text("Supprimer"),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                            },
                            onDismissed: (direction) {
                              if (notification.id != null) {
                                ctl.deleteNotification(notification.id!);
                              }
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.white),
                            ),
                            child: Container(
                              color: isUnread
                                  ? AppColors.primary.withOpacity(0.05)
                                  : Colors.transparent,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: isUnread
                                          ? AppColors.primary.withOpacity(0.1)
                                          : Colors.grey[100],
                                      child: SvgPicture.asset(
                                        'assets/images/svg/notif.svg',
                                        width: 24,
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
                                          width: 12,
                                          height: 12,
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
                                title: Text(
                                  notification.titre ?? "Notification",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isUnread
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isUnread
                                        ? Colors.black87
                                        : Colors.grey[700],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      notification.libelle ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isUnread
                                            ? Colors.black54
                                            : Colors.grey[500],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 12, color: Colors.grey[400]),
                                        const SizedBox(width: 4),
                                        Text(
                                          notification.dateFormatted,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isUnread)
                                      const Icon(Icons.circle,
                                          size: 8, color: AppColors.primary),
                                    const Gap(4),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 14, color: Colors.grey[300]),
                                  ],
                                ),
                                onTap: () {
                                  if (isUnread && notification.id != null) {
                                    ctl.markAsRead(notification.id!);
                                  }
                                  Get.to(() => DetailNotifPage(
                                      notification: notification));
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        );
      },
    );
  }
}
