import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/static/home/sub_pages/select_entreprise_bottom_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EnterpriseSelectorAppBarTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSelectionChanged;

  const EnterpriseSelectorAppBarTitle({
    super.key,
    required this.title,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CBottomSheet.show(
        child: const SelectEntrepriseBottomPage(),
        height: 400,
        isScrollControlled: true,
      ).then((e) {
        if (e != null) {
          onSelectionChanged();
        }
      }),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.7),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.storefront_rounded,
                color: Colors.white,
                size: 18,
              ),
              const Gap(6),
              Flexible(
                child: Text(
                  title.isEmpty ? "Sélectionner une entreprise" : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(6),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.secondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
