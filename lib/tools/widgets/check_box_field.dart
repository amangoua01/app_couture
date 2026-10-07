import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Case à cocher habillée comme le reste des champs de l'app (bordure
/// teintée, coins arrondis) plutôt que le `CheckboxListTile` Material brut
/// — bleu par défaut, sans lien avec l'identité de l'app.
class CheckBoxField extends StatelessWidget {
  final bool? value;
  final String title;
  final String? subtitle;
  final bool enabled;
  final Function(bool?)? onChanged;

  const CheckBoxField({
    this.value = false,
    this.enabled = true,
    required this.title,
    this.subtitle,
    this.onChanged,
    super.key,
  });

  bool get _checked => value ?? false;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? () => onChanged?.call(!_checked) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:
                  _checked
                      ? AppColors.primary.withValues(alpha: 0.05)
                      : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                    _checked
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : AppColors.fieldBorder,
                width: _checked ? 1.3 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CheckSquare(checked: _checked),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const Gap(3),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckSquare extends StatelessWidget {
  final bool checked;
  const _CheckSquare({required this.checked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(top: 1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: checked ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: checked ? AppColors.primary : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child:
          checked
              ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
              : null,
    );
  }
}
