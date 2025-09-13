import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final bool condition;
  final Widget placeholder;
  final Widget child;
  const PlaceholderWidget({
    required this.child,
    this.condition = true,
    this.placeholder = const SizedBox.shrink(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return child;
    } else {
      return placeholder;
    }
  }
}
