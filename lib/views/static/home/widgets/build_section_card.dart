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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.06)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
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
          // Toutes les lignes partagent ce Material : sans lui, InkWell peint
          // son ondulation derrière le fond du Container ci-dessus et reste
          // invisible au tap.
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  _StepRow(step: steps[i], color: color),
                  if (i < steps.length - 1)
                    Divider(height: 1, indent: 60, color: Colors.grey[100]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final RoadmapStep step;
  final Color color;

  const _StepRow({required this.step, required this.color});

  static const _success = Color(0xFF1C9A5B);

  @override
  Widget build(BuildContext context) {
    // Trois états distincts : terminée (pastille verte + coche), disponible
    // (pastille colorée + numéro, cliquable) et verrouillée (grise + cadenas,
    // non cliquable) — avant, "verrouillée" et "terminée" avaient le même
    // rendu gris, ce qui ne permettait pas de voir ce qui avait déjà été
    // fait.
    final isLocked = !step.enabled && !step.done;

    return InkWell(
      onTap: step.enabled ? step.onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color:
                    step.done
                        ? _success
                        : (step.enabled ? color.withValues(alpha: 0.1) : Colors.grey[100]),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child:
                  step.done
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                      : Text(
                        step.number,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: step.enabled ? color : Colors.grey[400],
                          fontSize: 13,
                        ),
                      ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          step.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color:
                                isLocked ? Colors.grey : AppColors.textDark,
                          ),
                        ),
                      ),
                      if (step.done) ...[
                        const Gap(6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: _success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Terminé",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(2),
                  Text(
                    step.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            if (step.enabled)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.withValues(alpha: 0.5),
                size: 14,
              )
            else if (isLocked)
              Icon(Icons.lock_outline_rounded, color: Colors.grey[300], size: 15),
          ],
        ),
      ),
    );
  }
}
