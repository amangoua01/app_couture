import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? color;
  final bool visible;
  final void Function()? onTap;

  const SettingTile({
    required this.title,
    this.visible = true,
    this.icon,
    this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: icon != null
                ? Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (color ?? AppColors.primary).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(icon, color: color ?? AppColors.primary, size: 20),
                  )
                : null,
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color ?? Colors.black87,
                fontSize: 15,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ),
          const Divider(height: 1, indent: 50),
        ],
      ),
    );
  }
}
