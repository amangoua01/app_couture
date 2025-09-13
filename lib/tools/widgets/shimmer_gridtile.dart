import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGridtile extends StatelessWidget {
  const ShimmerGridtile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Card(),
      ),
    );
  }
}
