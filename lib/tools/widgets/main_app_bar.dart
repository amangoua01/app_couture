import 'package:ateliya/tools/widgets/enterprise_selector_app_bar_title.dart';
import 'package:ateliya/tools/widgets/notif_badge_icon.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String enterpriseTitle;
  final VoidCallback onSelectionChanged;
  final int notifCount;
  final VoidCallback onNotifRefresh;

  const MainAppBar({
    super.key,
    required this.enterpriseTitle,
    required this.onSelectionChanged,
    required this.notifCount,
    required this.onNotifRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Center(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Image.asset(
              "assets/images/logo_ateliya.png",
              fit: BoxFit.contain,
              width: 25,
              height: 25,
            ),
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      title: EnterpriseSelectorAppBarTitle(
        title: enterpriseTitle,
        onSelectionChanged: onSelectionChanged,
      ),
      actions: [
        NotifBadgeIcon(
          count: notifCount,
          onRefresh: onNotifRefresh,
        ),
      ],
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
