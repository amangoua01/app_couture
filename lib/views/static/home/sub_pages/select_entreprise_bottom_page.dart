import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/wrapper_listview.dart';
import 'package:app_couture/views/controllers/home/select_entreprise_bottom_page_vctl.dart';
import 'package:flutter/material.dart';
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
                      itemBuilder: (_, __) => const Center(
                        child: Text("Contenu de l'Entreprise 1"),
                      ),
                    ),
                    WrapperListview(
                      isLoading: ctl.isLoading,
                      items: ctl.entities.surcusales,
                      onRefresh: ctl.fetchEntrepriseEntities,
                      itemBuilder: (_, __) => const Center(
                        child: Text("Contenu de l'Entreprise 2"),
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
