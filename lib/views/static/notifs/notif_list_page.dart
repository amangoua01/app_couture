import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/shimmer_listtile.dart';
import 'package:ateliya/views/controllers/notifs/notif_list_vctl.dart';
import 'package:ateliya/views/static/notifs/detail_notif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

                          return Container(
                            color: isUnread
                                ? AppColors.primary.withOpacity(0.05)
                                : Colors.transparent,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isUnread
                                    ? AppColors.primary
                                    : AppColors.primary.withOpacity(0.3),
                                child: SvgPicture.asset(
                                  'assets/images/svg/notif.svg',
                                  colorFilter: ColorFilter.mode(
                                    isUnread ? Colors.white : AppColors.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              title: Text(
                                notification.titre ?? "Notification",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: isUnread
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.libelle ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.dateFormatted,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15),
                              onTap: () {
                                if (isUnread && notification.id != null) {
                                  ctl.markAsRead(notification.id!);
                                }
                                Get.to(() => DetailNotifPage(
                                    notification: notification));
                              },
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
