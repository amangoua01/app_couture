import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  const SettingTile({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: Colors.grey),
      ),
      child: ListTile(
        dense: true,
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
      ),
    );
  }
}
