import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/wrapper_gridview.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/home/boutique_page_vctl.dart';
import 'package:ateliya/views/static/home/detail_boutique_item_page.dart';
import 'package:ateliya/views/static/ventes/edition_vente_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BoutiquePage extends StatelessWidget {
  const BoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BoutiquePageVctl(),
        builder: (ctl) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA), // Fond moderne
            appBar: AppBar(
              elevation: 0,
              title: const Text(
                "Boutiques",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              bottom: ternaryFn(
                condition: ctl.isSearching,
                ifTrue: PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: CTextFormField(
                      hintText: 'Rechercher un modèle...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                ifFalse: null,
              ),
              actions: [
                IconButton(
                  icon: Icon(ctl.isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    ctl.isSearching = !ctl.isSearching;
                    ctl.update();
                  },
                ),
                IconButton(
                  icon: Icon(
                    ctl.isGridView
                        ? Icons.view_list_rounded
                        : Icons.grid_view_rounded,
                  ),
                  onPressed: () {
                    ctl.isGridView = !ctl.isGridView;
                    ctl.update();
                  },
                ),
                const Gap(10),
              ],
            ),
            body: PlaceholderWidget(
              condition: ctl.isGridView,
              placeholder: WrapperListview(
                onRefresh: ctl.fetchData,
                isLoading: ctl.isLoading,
                items: ctl.data,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemBuilder: (e, i) => _buildListItem(e, ctl, context),
              ),
              child: WrapperGridview(
                onRefresh: ctl.fetchData,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                isLoading: ctl.isLoading,
                items: ctl.data,
                itemBuilder: (e, i) => _buildGridItem(e, ctl, context),
              ),
            ),
          );
        });
  }

  Widget _buildListItem(
      ModeleBoutique e, BoutiquePageVctl ctl, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(() => DetailBoutiqueItemPage(e)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PlaceholderBuilder(
                      placeholder: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset("assets/images/model1.png"),
                      ),
                      condition: (e.modele?.photo is FichierServer) &&
                          (e.modele?.photo as FichierServer).fullUrl != null,
                      builder: () => Image.network(
                        (e.modele!.photo as FichierServer).fullUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.modele?.libelle ?? "Sans nom",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              e.taille.value,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            "${e.quantite} en stock",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Gap(6),
                      Text(
                        e.prix.toAmount(unit: "F"),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert_rounded, color: Colors.grey[400]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (context) => getMenus(context, e, ctl),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(
      ModeleBoutique e, BoutiquePageVctl ctl, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.to(() => DetailBoutiqueItemPage(e)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: PlaceholderBuilder(
                          placeholder: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Image.asset("assets/images/model1.png"),
                          ),
                          condition: (e.modele?.photo is FichierServer) &&
                              (e.modele?.photo as FichierServer).fullUrl !=
                                  null,
                          builder: () => Image.network(
                            (e.modele!.photo as FichierServer).fullUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5)
                          ],
                        ),
                        child: PopupMenuButton(
                          icon: const Icon(Icons.more_horiz_rounded,
                              size: 20, color: Colors.black54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          itemBuilder: (context) => getMenus(context, e, ctl),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          e.taille.value,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.modele?.libelle ?? "Sans nom",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      "${e.quantite} en stock",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Gap(8),
                    Text(
                      e.prix.toAmount(unit: "F"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PopupMenuItem<String>> getMenus(BuildContext _,
          ModeleBoutique modeleBoutique, BoutiquePageVctl ctl) =>
      [
        "Faire une vente",
        // "Voir les ventes",
        // "Supprimer",
      ]
          .map(
            (e) => PopupMenuItem(
              height: 40,
              value: e,
              child: Text(e),
              onTap: () async {
                switch (e) {
                  case "Faire une vente":
                    final res =
                        await Get.to(() => EditionVentePage(modeleBoutique));
                    if (res != null) {
                      ctl.fetchData();
                    }
                    break;
                  // case "Entrer stock":
                  //   CBottomSheet.show(
                  //     child: const EditionEntreeStock(
                  //       isEntreeStock: true,
                  //     ),
                  //   );
                  //   break;
                  // case "Sorti stock":
                  //   CBottomSheet.show(
                  //     child: const EditionEntreeStock(
                  //       isEntreeStock: false,
                  //     ),
                  //   );
                  //   break;
                  // case "Réserver":
                  //   break;
                  // case "Payer":
                  //   Get.to(() => EditionVentePage(modeleBoutique));
                  //   break;
                }
              },
            ),
          )
          .toList();
}
