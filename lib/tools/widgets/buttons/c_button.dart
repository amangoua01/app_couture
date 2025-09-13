import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/placeholder_builder.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final double radius, height, highlightElevation;
  final Color color, textColor;
  final bool enabled;
  final FontWeight fontWeight;
  final Widget? icon;
  final Color disabledColor;
  final BorderSide border;

  const CButton({
    this.title = "Valider",
    this.border = BorderSide.none,
    this.disabledColor = AppColors.primary,
    this.icon,
    this.enabled = true,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.radius = 10,
    this.height = 45,
    this.fontWeight = FontWeight.normal,
    this.highlightElevation = 0,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: height,
      highlightElevation: highlightElevation,
      minWidth: double.infinity,
      color: color,
      shape: RoundedRectangleBorder(
        side: border,
        borderRadius: BorderRadius.circular(radius),
      ),
      disabledColor: disabledColor.withAlpha(100),
      onPressed: (enabled) ? onPressed : null,
      child: PlaceholderBuilder(
        condition: icon != null,
        placeholder: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
          ),
        ),
        builder: () {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon!,
              const Gap(10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
