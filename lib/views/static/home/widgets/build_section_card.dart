import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/static/home/widgets/road_map_step.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuildSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<RoadmapStep> steps;

  const BuildSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: const Border(
                bottom: BorderSide(color: AppColors.fieldBorder, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.15)),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: steps.asMap().entries.map((entry) {
                final step = entry.value;
                return Column(
                  children: [
                    ListTile(
                      minVerticalPadding: 12,
                      leading: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: step.enabled
                              ? color.withOpacity(0.1)
                              : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          step.number,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: step.enabled ? color : Colors.grey[900],
                            fontSize: 13,
                          ),
                        ),
                      ),
                      title: Text(
                        step.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: step.enabled ? Colors.black : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        step.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.grey[400], size: 14),
                      onTap: step.enabled ? step.onTap : null,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
