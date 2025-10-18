import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/wrapper_listview.dart';
import 'package:app_couture/views/static/surcursales/edition_surcusale_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SurcursalesListPage extends StatelessWidget {
  const SurcursalesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes surcusales")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const EditionSurcusalePage()),
        child: const Icon(Icons.add),
      ),
      body: WrapperListview(
        items: const [1, 2, 3, 4, 5],
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.3),
            child: SvgPicture.asset(
              'assets/images/svg/shop.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          title: Text("Surcusale ${i + 1}"),
          subtitle: const Text("0123456789"),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
          onTap: () => Get.to(() => const EditionSurcusalePage()),
        ),
      ),
    );
  }
}
