import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Champ de recherche filtrant les réglages au fil de la frappe.
class SettingsSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SettingsSearchField({
    required this.controller,
    required this.onChanged,
    this.hintText = "Rechercher un réglage...",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          suffixIcon:
              controller.text.isEmpty
                  ? null
                  : IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged("");
                    },
                  ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
