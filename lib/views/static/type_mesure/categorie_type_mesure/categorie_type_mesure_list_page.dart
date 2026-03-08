import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/controllers/type_mesure/categorie_type_mesure/categorie_type_mesure_list_vctl.dart';
import 'package:ateliya/views/static/type_mesure/categorie_type_mesure/edition_categorie_type_mesure_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorieTypeMesureListPage extends StatelessWidget {
  final TypeMesure typeMesure;
  const CategorieTypeMesureListPage(
    this.typeMesure, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CategorieTypeMesureListVctl(typeMesure),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F9FC),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "Catégories de mesures",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          floatingActionButton: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: ctl.isOrderChanged
                ? FloatingActionButton.extended(
                    key: const ValueKey("save_btn"),
                    onPressed: ctl.saveNewOrder,
                    backgroundColor: Colors.green,
                    elevation: 4,
                    icon: const Icon(Icons.check_rounded, color: Colors.white),
                    label: const Text(
                      "Enregistrer l'ordre",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                : FloatingActionButton.extended(
                    key: const ValueKey("add_btn"),
                    onPressed: () async {
                      if (ctl.categories.isEmpty) {
                        await ctl.getCategories();
                      }
                      CBottomSheet.show(
                        child: EditionCategorieTypeMesureSubPage(
                          selectedCategoriesIds: ctl.selected(),
                          categories: ctl.categories,
                          onSaved: ctl.submit,
                        ),
                      );
                    },
                    backgroundColor: AppColors.primary,
                    elevation: 4,
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    label: const Text(
                      "Ajouter",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
          body: ctl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: ctl.getList,
                  child: ctl.categoriesType.isEmpty
                      ? ListView(
                          padding: const EdgeInsets.all(32),
                          children: const [
                            SizedBox(height: 100),
                            Center(
                              child: Text(
                                "Aucune catégorie de mesure",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        )
                      : ReorderableListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          onReorder: ctl.onReorder,
                          itemCount: ctl.categoriesType.length,
                          proxyDecorator: (child, index, animation) {
                            return AnimatedBuilder(
                              animation: animation,
                              builder: (BuildContext context, Widget? child) {
                                final double animValue =
                                    Curves.easeInOut.transform(animation.value);
                                final double elevation = animValue * 10;
                                final double scale = 1 + (animValue * 0.05);

                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        if (animValue > 0)
                                          BoxShadow(
                                            color: Colors.black.withAlpha(
                                                (animValue * 50).toInt()),
                                            blurRadius: elevation * 2,
                                            offset: Offset(0, elevation),
                                          ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: child,
                            );
                          },
                          itemBuilder: (context, i) {
                            final e = ctl.categoriesType[i];
                            return Container(
                              key: ValueKey(e.id.value),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                leading: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withAlpha(20),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.drag_indicator_rounded,
                                      color: AppColors.primary,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  e.categorieMesure?.libelle ?? 'Aucun nom',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () => ctl.delete(e.id.value),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.red.withAlpha(20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
        );
      },
    );
  }
}
