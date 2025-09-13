import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/wrapper_gridview.dart';
import 'package:app_couture/views/static/home/detail_boutique_item_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoutiquePage extends StatelessWidget {
  const BoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Boutiques"),
        backgroundColor: AppColors.primary,
      ),
      body: WrapperGridview(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        isLoading: false,
        items: List.generate(10, (i) => i),
        itemBuilder: (e, i) => GestureDetector(
          onTap: () => Get.to(() => const DetailBoutiqueItemPage()),
          child: Card(
            elevation: 0,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        child: Image.asset(
                          "assets/images/model1.png",
                          fit: BoxFit.cover,
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
                            "Réserver",
                            "Payer",
                          ]
                              .map(
                                (e) => PopupMenuItem(
                                  height: 40,
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: const ListTile(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
