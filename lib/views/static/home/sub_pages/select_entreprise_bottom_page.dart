import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/wrapper_listview.dart';
import 'package:flutter/material.dart';

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
            child: TabBarView(
              children: [
                WrapperListview(
                  itemBuilder: (_, __) => const Center(
                    child: Text("Contenu de l'Entreprise 1"),
                  ),
                ),
                WrapperListview(
                  itemBuilder: (_, __) => const Center(
                    child: Text("Contenu de l'Entreprise 2"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
