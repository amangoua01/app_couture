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
          gradient: LinearGradient(
            colors: [
              Color(0xFF091613),
              Color(0xFF16322B),
              Color(0xFF0E2A22),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: child);
  }
}
