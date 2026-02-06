import 'package:ateliya/views/static/notifs/notif_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotifBadgeIcon extends StatelessWidget {
  final int count;
  final VoidCallback? onRefresh;
  final Color? color;
  final double size;

  const NotifBadgeIcon({
    super.key,
    required this.count,
    this.onRefresh,
    this.color = Colors.white,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text("$count"),
      isLabelVisible: count > 0,
      offset: const Offset(-5, 5),
      backgroundColor: Colors.red,
      child: IconButton(
        onPressed: () =>
            Get.to(() => const NotifListPage())?.then((_) => onRefresh?.call()),
        icon: SvgPicture.asset(
          "assets/images/svg/notif.svg",
          width: size,
          colorFilter: ColorFilter.mode(
            color ?? Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
