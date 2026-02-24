import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final Color? iconBgColor;
  final bool visible;
  final bool showDivider;
  final Widget? trailing;
  final void Function()? onTap;

  const SettingTile({
    required this.title,
    this.subtitle,
    this.visible = true,
    this.showDivider = true,
    this.icon,
    this.color,
    this.iconBgColor,
    this.trailing,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final tileColor = color ?? Colors.black87;
    final accentColor = color ?? AppColors.primary;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color:
                            iconBgColor ?? accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: accentColor, size: 18),
                    ),
                    const Gap(14),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: tileColor,
                            fontSize: 14.5,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const Gap(2),
                          Text(
                            subtitle!,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ],
                    ),
                  ),
                  trailing ??
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: Colors.grey[350],
                      ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: icon != null ? 66 : 16,
            endIndent: 0,
            color: Colors.grey[150],
          ),
      ],
    );
  }
}
