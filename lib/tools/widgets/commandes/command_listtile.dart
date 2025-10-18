import 'package:flutter/material.dart';

class CommandListtile extends StatelessWidget {
  final String title;
  final String value;
  const CommandListtile({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(value),
        ],
      ),
    );
  }
}
