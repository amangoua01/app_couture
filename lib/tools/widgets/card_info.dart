import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class CardInfo extends StatelessWidget {
  final String icon;
  final String value;
  final Color color;
  final double width, height;
  const CardInfo({
    super.key,
    required this.icon,
    this.width = 20,
    this.height = 20,
    required this.value,
    this.color = AppColors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          PlaceholderWidget(
            condition: icon.endsWith(".svg"),
            placeholder: Image.asset(
              icon,
              width: width,
              height: height,
            ),
            child: SvgPicture.asset(
              icon,
              width: width,
              height: height,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
