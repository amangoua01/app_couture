import 'package:flutter/material.dart';

class CCard extends StatelessWidget {
  final Widget child;
  const CCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xFF16322B),
        ),
        child: child);
  }
}
