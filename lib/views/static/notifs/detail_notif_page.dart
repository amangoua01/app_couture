import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailNotifPage extends StatelessWidget {
  const DetailNotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails")),
      body: PlaceholderWidget(
        condition: true,
        placeholder: const Center(child: CircularProgressIndicator()),
        child: ListView(
          children: [
            ListTile(
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
              title: const Text('data'),
              subtitle: const Text('data'),
            ),
            const ListTile(title: SelectableText('body de la notification')),
          ],
        ),
      ),
    );
  }
}
