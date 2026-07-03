import 'package:flutter/material.dart';

class RoadmapStep {
  final String number;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool enabled;

  const RoadmapStep({
    required this.number,
    required this.title,
    required this.description,
    required this.onTap,
    this.enabled = true,
  });
}
