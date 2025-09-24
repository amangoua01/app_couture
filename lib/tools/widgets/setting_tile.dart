import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const SettingTile({required this.title, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
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
      ),
    );
  }
}
