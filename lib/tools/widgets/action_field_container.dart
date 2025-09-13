import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ActionFieldContainer extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final String buttonTitle;
  final Widget icon;
  const ActionFieldContainer({
    required this.child,
    this.icon = const Icon(Icons.add, color: AppColors.primary, size: 18),
    this.buttonTitle = "Ajouter un élément",
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: (onTap != null) ? const EdgeInsets.all(10) : null,
      margin: (onTap == null) ? null : const EdgeInsets.only(bottom: 20),
      decoration: onTap == null
          ? null
          : BoxDecoration(
              color: AppColors.blocColor,
              borderRadius: BorderRadius.circular(10),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          child,
          Visibility(
            visible: onTap != null,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    icon,
                    const Gap(5),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        buttonTitle,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ],
                ),
                const Gap(10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
