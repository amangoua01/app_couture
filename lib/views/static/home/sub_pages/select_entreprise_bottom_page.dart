import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/c_tab_bar.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/home/select_entreprise_bottom_page_vctl.dart';
import 'package:ateliya/views/static/home/widgets/build_entity_item.dart';
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 6),
            child: Text(
              "Espace de travail",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Gap(6),
          const CTabBar(
            tabs: ["Boutiques", "Succursales"],
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
          const Gap(20),
          Expanded(
            child: GetBuilder(
              init: SelectEntrepriseBottomPageVctl(),
              builder: (ctl) {
                return TabBarView(
                  children: [
                    WrapperListview(
                      padding: EdgeInsets.zero,
                      isLoading: ctl.isLoading,
                      items: ctl.entities.boutiques,
                      onRefresh: ctl.fetchEntrepriseEntities,
                      itemBuilder: (e, _) {
                        final isSelected =
                            (ctl.getEntite().value is Boutique) &&
                                (ctl.getEntite().value as Boutique).id == e.id;
                        return BuildEntityItem(
                          title: e.libelle.value,
                          subtitle: e.contact.value,
                          iconPath: "assets/images/svg/boutique.svg",
                          isSelected: isSelected,
                          onTap: () => ctl.onSelectEntity(e),
                        );
                      },
                    ),
                    WrapperListview(
                      padding: EdgeInsets.zero,
                      isLoading: ctl.isLoading,
                      items: ctl.entities.surcusales,
                      onRefresh: ctl.fetchEntrepriseEntities,
                      itemBuilder: (e, __) {
                        final isSelected = (ctl.getEntite().value
                                is Succursale) &&
                            (ctl.getEntite().value as Succursale).id == e.id;
                        return BuildEntityItem(
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
}
