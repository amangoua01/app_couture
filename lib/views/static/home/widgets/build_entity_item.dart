import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class BuildEntityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;
  const BuildEntityItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.iconPath,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5),
            width: isSelected ? 1 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF1F3F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? AppColors.primary : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  if (subtitle.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android_rounded,
                          size: 12,
                          color:
                              isSelected ? AppColors.primary : Colors.grey[500],
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              color:
                                  isSelected ? AppColors.primary : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      "Aucun contact",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            const Gap(10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: isSelected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      key: ValueKey('selected'),
                      color: AppColors.primary,
                      size: 22,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      key: ValueKey('unselected'),
                      color: Colors.grey,
                      size: 20,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
