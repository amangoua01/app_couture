import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/views/static/notifs/detail_notif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotifListPage extends StatelessWidget {
  const NotifListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.3),
            child: SvgPicture.asset(
              'assets/images/svg/notif.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          title: const Text(
            "Titre de la notification",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Text(
            "Description de la notification",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
          onTap: () => Get.to(() => const DetailNotifPage()),
        ),
        itemCount: 10,
      ),
    );
  }
}
