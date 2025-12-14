import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: CheckboxListTile(
        enabled: enabled,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        value: value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(title),
        subtitle: PlaceholderWidget(
          condition: subtitle != null,
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.blue, size: 17),
              const Gap(10),
              Expanded(
                child: Text(
                  subtitle.value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                        fontSize: 10.5,
                      ),
                ),
              ),
            ],
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
