import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InfoTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;
  final double textSize;
  const InfoTitle({
    required this.text,
    this.textSize = 13,
    this.padding = const EdgeInsets.only(left: 15, right: 15, bottom: 35),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.blue, size: 17),
          const Gap(10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                    fontSize: textSize,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
