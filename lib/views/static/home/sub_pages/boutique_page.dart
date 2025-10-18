import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/tools/widgets/wrapper_gridview.dart';
import 'package:app_couture/views/static/boutiques/edition_entree_stock.dart';
import 'package:app_couture/views/static/home/detail_boutique_item_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoutiquePage extends StatelessWidget {
  const BoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Boutiques")),
      body: WrapperGridview(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        isLoading: false,
        items: List.generate(10, (i) => i),
        itemBuilder: (e, i) => GestureDetector(
          onTap: () => Get.to(() => const DetailBoutiqueItemPage()),
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
                            color: AppColors.primary.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            "assets/images/model1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          child: const Badge(
                            label: Text("10 disp."),
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          position: PopupMenuPosition.under,
                          menuPadding: const EdgeInsets.all(5),
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (_) => [
                            "Entrer stock",
                            "Sorti stock",
                            "Réserver",
                            "Payer",
                          ]
                              .map(
                                (e) => PopupMenuItem(
                                  height: 40,
                                  value: e,
                                  child: Text(e),
                                  onTap: () {
                                    switch (e) {
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
                                        break;
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const ListTile(
                  title: Text(
                    "Tunique africaine homme",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  subtitle: Text(
                    "25 000 FCFA",
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
