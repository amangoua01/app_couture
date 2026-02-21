import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/home/select_entreprise_bottom_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SelectEntrepriseBottomPage extends StatelessWidget {
  const SelectEntrepriseBottomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Boutiques"),
                  Tab(text: "Succursales"),
                ],
              ),
            ),
          ),
          const Gap(20),
          Expanded(
            child: GetBuilder(
              init: SelectEntrepriseBottomPageVctl(),
              builder: (ctl) {
                return TabBarView(
                  children: [
                    WrapperListview(
                      isLoading: ctl.isLoading,
                      items: ctl.entities.boutiques,
                      onRefresh: ctl.fetchEntrepriseEntities,
                      itemBuilder: (e, _) {
                        final isSelected =
                            (ctl.getEntite().value is Boutique) &&
                                (ctl.getEntite().value as Boutique).id == e.id;
                        return _buildEntityItem(
                          title: e.libelle.value,
                          subtitle: e.contact.value,
                          iconPath: "assets/images/svg/boutique.svg",
                          isSelected: isSelected,
                          onTap: () => ctl.onSelectEntity(e),
                        );
                      },
                    ),
                    WrapperListview(
                      isLoading: ctl.isLoading,
                      items: ctl.entities.surcusales,
                      onRefresh: ctl.fetchEntrepriseEntities,
                      itemBuilder: (e, __) {
                        final isSelected = (ctl.getEntite().value
                                is Succursale) &&
                            (ctl.getEntite().value as Succursale).id == e.id;
                        return _buildEntityItem(
                          title: e.libelle.value,
                          subtitle: e.contact.value,
                          iconPath: "assets/images/svg/store.svg",
                          isSelected: isSelected,
                          onTap: () => ctl.onSelectEntity(e),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntityItem({
    required String title,
    required String subtitle,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Gap(15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
