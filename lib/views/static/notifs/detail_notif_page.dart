import 'package:ateliya/data/models/notification.dart' as notif;
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailNotifPage extends StatelessWidget {
  final notif.Notification notification;

  const DetailNotifPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: SvgPicture.asset(
                "assets/images/svg/notif.svg",
                height: 30,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            title: Text(
              notification.titre ?? 'Notification',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              notification.dateFormatted,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          SelectableText(
            notification.libelle ?? 'Aucun contenu',
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
