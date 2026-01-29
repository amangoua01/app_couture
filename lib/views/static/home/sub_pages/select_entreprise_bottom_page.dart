import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/home/select_entreprise_bottom_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SelectEntrepriseBottomPage extends StatelessWidget {
  const SelectEntrepriseBottomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.primary,
            tabs: [
              Tab(text: "Boutiques"),
              Tab(text: "Succursales"),
            ],
          ),
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
                      itemBuilder: (e, _) => ListTile(
                        leading: CircleAvatar(
                          child: SvgPicture.asset(
                            "assets/images/svg/boutique.svg",
                            width: 25,
                            height: 25,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        title: Text(e.libelle.value),
                        subtitle: Text(e.contact.value),
                        trailing: Visibility(
                          visible: (ctl.setEntite is Boutique) &&
                              (ctl.setEntite as Boutique).id == e.id,
                          child: SvgPicture.asset(
                            "assets/images/svg/pin.svg",
                            width: 25,
                            height: 25,
                          ),
                        ),
                        onTap: () => ctl.onSelectEntity(e),
                      ),
                    ),
                    WrapperListview(
                      isLoading: ctl.isLoading,
                      items: ctl.entities.surcusales,
                      onRefresh: ctl.fetchEntrepriseEntities,
                      itemBuilder: (e, __) => ListTile(
                        leading: CircleAvatar(
                          child: SvgPicture.asset(
                            "assets/images/svg/store.svg",
                            width: 25,
                            height: 25,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        title: Text(e.libelle.value),
                        subtitle: Text(e.contact.value),
                        trailing: Visibility(
                          visible: (ctl.setEntite is Succursale) &&
                              (ctl.setEntite as Succursale).id == e.id,
                          child: SvgPicture.asset(
                            "assets/images/svg/pin.svg",
                            width: 25,
                            height: 25,
                          ),
                        ),
                        onTap: () => ctl.onSelectEntity(e),
                      ),
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
