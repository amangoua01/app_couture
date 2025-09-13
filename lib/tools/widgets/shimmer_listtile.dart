import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListtile extends StatelessWidget {
  const ShimmerListtile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: ListTile(
        leading: const CircleAvatar(),
        title: Container(
          color: Colors.black,
          width: double.infinity,
          height: 15.0,
          child: const Text("data"),
        ),
        subtitle: Container(
          color: Colors.black,
          width: double.infinity,
          height: 15.0,
          child: const Text("data"),
        ),
        trailing: Container(
          color: Colors.black,
          width: 30,
          height: 37.0,
          child: const Text("data"),
        ),
      ),
    );
  }
}
