import 'package:ateliya/tools/components/card_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

/// Silhouette de chargement d'une ligne, dans la même carte individuelle que
/// les vraies lignes (voir ListItem) pour éviter tout saut visuel.
class ShimmerListtile extends StatelessWidget {
  const ShimmerListtile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: CardStyle.decoration(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 13,
                    color: Colors.black,
                  ),
                  const Gap(8),
                  Container(width: 120, height: 11, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
