import 'package:flutter/material.dart';

class BottomSheetDot extends StatelessWidget {
  final double height, width;
  final BorderRadiusGeometry? radius;
  final Color color;
  const BottomSheetDot({
    this.color = Colors.black,
    this.height = 6,
    this.width = 60,
    this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4, top: 14),
      height: 8,
      width: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius ?? BorderRadius.circular(20),
      ),
    );
  }
}
