import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/views/static/commandes/detail_command_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class CommandTile extends StatelessWidget {
  const CommandTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const DetailCommandPage()),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withAlpha(100)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateTime.now().toFrenchDateTime,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  'Konaté Hamed',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Chemise, Pantalon, Cravate, Veste, Chapeau",
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Gap(20),
                CircleAvatar(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      IcoFontIcons.print,
                    ),
                  ),
                )
              ],
            ),
            const Gap(10),
            Text('${(50 * 0.5).toInt()} %'),
            const Gap(10),
            LinearProgressIndicator(
              color: AppColors.primary,
              value: 0.5,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: AppColors.primary.withAlpha(100),
            ),
            const Gap(10),
            const Row(
              children: [
                Expanded(
                  child: Text("10 000 FCFA"),
                ),
                Text(
                  "10 000 FCFA",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
