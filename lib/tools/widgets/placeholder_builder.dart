import 'package:flutter/material.dart';

class PlaceholderBuilder extends StatelessWidget {
  final bool condition;
  final Widget placeholder;
  final Widget Function() builder;
  const PlaceholderBuilder({
    required this.builder,
    this.condition = true,
    this.placeholder = const SizedBox.shrink(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return builder();
    } else {
      return placeholder;
    }
  }
}
