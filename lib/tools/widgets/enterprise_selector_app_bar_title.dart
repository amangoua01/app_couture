import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/static/home/sub_pages/select_entreprise_bottom_page.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
      ).then((e) {
        if (e != null) {
          onSelectionChanged();
        }
      }),
      child: Container(
        width: double.infinity,
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.to(() => const PrintListPage()),
              child: const CircleAvatar(
                radius: 15,
                child: Icon(Icons.print, size: 15),
              ),
            ),
            const Gap(10),
            Expanded(
              child: Text(
                title.isEmpty ? "Sélectionner une entreprise" : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
