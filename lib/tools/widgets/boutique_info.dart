import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BoutiqueInfo extends StatelessWidget {
  final String info;
  final String value;
  final Color? valueColor;
  const BoutiqueInfo({
    super.key,
    required this.info,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(10),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
