import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/static/notifs/notif_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotifBadgeIcon extends StatelessWidget {
  final int count;
  final VoidCallback? onRefresh;
  final Color? color;
  final double size;
  final bool isPremiumStyle;

  const NotifBadgeIcon({
    super.key,
    required this.count,
    this.onRefresh,
    this.color = Colors.white,
    this.size = 30,
    this.isPremiumStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconButton = IconButton(
      onPressed: () =>
          Get.to(() => const NotifListPage())?.then((_) => onRefresh?.call()),
      icon: SvgPicture.asset(
        "assets/images/svg/notif.svg",
        width: isPremiumStyle ? 18 : size,
        colorFilter: ColorFilter.mode(
          isPremiumStyle ? AppColors.secondary : (color ?? Colors.white),
          BlendMode.srcIn,
        ),
      ),
      padding: isPremiumStyle ? EdgeInsets.zero : const EdgeInsets.all(8),
      constraints: isPremiumStyle ? const BoxConstraints() : null,
    );

    if (isPremiumStyle) {
      iconButton = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.secondary.withOpacity(0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: iconButton,
      );
    }

    return Badge(
      label: Text(
        "$count",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 9,
          color: Colors.white,
        ),
      ),
      isLabelVisible: count > 0,
      offset: isPremiumStyle ? const Offset(-2, 2) : const Offset(-5, 5),
      backgroundColor: const Color(0xFFFF4D4D), // Modern coral red for notification badge
      child: iconButton,
    );
  }
}
