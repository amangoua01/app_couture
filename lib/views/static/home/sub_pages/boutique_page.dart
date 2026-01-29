import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/boutique_info.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/wrapper_gridview.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/home/boutique_page_vctl.dart';
import 'package:ateliya/views/static/boutiques/edition_entree_stock.dart';
import 'package:ateliya/views/static/home/detail_boutique_item_page.dart';
import 'package:ateliya/views/static/ventes/edition_vente_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoutiquePage extends StatelessWidget {
  const BoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BoutiquePageVctl(),
        builder: (ctl) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Boutiques"),
              bottom: ternaryFn(
                condition: ctl.isSearching,
                ifTrue: const PreferredSize(
                  preferredSize: Size.fromHeight(90),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: CTextFormField(
                      hintText: 'Rechercher',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                ifFalse: null,
              ),
              actions: [
                IconButton(
                  icon: Icon(ctl.isSearching ? Icons.search_off : Icons.search),
                  onPressed: () {
                    ctl.isSearching = !ctl.isSearching;
                    ctl.update();
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                ListTile(
                  title: const Text("Mode d'affichage"),
                  trailing: Icon(
                    ternaryFn(
                      condition: ctl.isGridView,
                      ifTrue: Icons.grid_view,
                      ifFalse: Icons.list,
                    ),
                    color: AppColors.green,
                  ),
                  onTap: () {
                    ctl.isGridView = !ctl.isGridView;
                    ctl.update();
                  },
                ),
                Expanded(
                  child: PlaceholderWidget(
                    condition: ctl.isGridView,
                    placeholder: WrapperListview(
                      onRefresh: ctl.fetchData,
                      isLoading: ctl.isLoading,
                      items: ctl.data,
                      itemBuilder: (e, i) => ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: PlaceholderBuilder(
                            placeholder: Image.asset(
                              "assets/images/model1.png",
                              fit: BoxFit.contain,
                            ),
                            builder: () {
                              return Image.network(
                                (e.modele!.photo as FichierServer).fullUrl!,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                        title: Text(e.modele?.libelle ?? "Aucun nom"),
                        subtitle: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(e.taille.value),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text("${e.quantite} unité(s) •"),
                            ),
                            Text(
                              e.prix.toAmount(unit: "F"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellow,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PopupMenuButton(
                              tooltip: "Options",
                              splashRadius: 20,
                              itemBuilder: (context) => getMenus(context, e),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 15),
                          ],
                        ),
                        onTap: () => Get.to(() => DetailBoutiqueItemPage(e)),
                      ),
                    ),
                    child: WrapperGridview(
                      onRefresh: ctl.fetchData,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                        bottom: 100,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .5,
                      ),
                      isLoading: ctl.isLoading,
                      items: ctl.data,
                      itemBuilder: (e, i) => GestureDetector(
                        onTap: () => Get.to(() => DetailBoutiqueItemPage(e)),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Align(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                        ),
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.primary.withAlpha(50),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: PlaceholderBuilder(
                                            placeholder: Image.asset(
                                              "assets/images/model1.png",
                                            ),
                                            condition: (e.modele?.photo
                                                    is FichierServer) &&
                                                (e.modele?.photo
                                                            as FichierServer)
                                                        .fullUrl !=
                                                    null,
                                            builder: () {
                                              return Image.network(
                                                (e.modele!.photo
                                                        as FichierServer)
                                                    .fullUrl!,
                                                fit: BoxFit.contain,
                                              );
                                            }),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: PopupMenuButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        position: PopupMenuPosition.under,
                                        menuPadding: const EdgeInsets.all(5),
                                        icon: const Icon(Icons.more_vert),
                                        itemBuilder: (context) =>
                                            getMenus(context, e),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.modele?.libelle ?? "Aucun nom",
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      BoutiqueInfo(
                                        info: "Taille",
                                        value: e.taille.value,
                                      ),
                                      BoutiqueInfo(
                                        info: "Prix",
                                        value: e.prix.toAmount(unit: "F"),
                                        valueColor: AppColors.yellow,
                                      ),
                                      BoutiqueInfo(
                                        info: "Stock",
                                        value: "${e.quantite} unité(s)",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<PopupMenuItem<String>> getMenus(
          BuildContext _, ModeleBoutique modeleBoutique) =>
      [
        "Faire une vente",
        "Voir les ventes",
        "Supprimer",
      ]
          .map(
            (e) => PopupMenuItem(
              height: 40,
              value: e,
              child: Text(e),
              onTap: () {
                switch (e) {
                  case "Faire une vente":
                    Get.to(() => EditionVentePage(modeleBoutique));
                    break;
                  case "Entrer stock":
                    CBottomSheet.show(
                      child: const EditionEntreeStock(
                        isEntreeStock: true,
                      ),
                    );
                    break;
                  case "Sorti stock":
                    CBottomSheet.show(
                      child: const EditionEntreeStock(
                        isEntreeStock: false,
                      ),
                    );
                    break;
                  case "Réserver":
                    break;
                  case "Payer":
                    Get.to(() => EditionVentePage(modeleBoutique));
                    break;
                }
              },
            ),
          )
          .toList();
}
