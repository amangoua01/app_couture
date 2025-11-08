import 'package:app_couture/data/models/type_mesure.dart';
import 'package:app_couture/tools/extensions/types/int.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/tools/widgets/wrapper_listview.dart';
import 'package:app_couture/views/controllers/type_mesure/categorie_type_mesure/categorie_type_mesure_list_vctl.dart';
import 'package:app_couture/views/static/type_mesure/categorie_type_mesure/edition_categorie_type_mesure_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          appBar: AppBar(title: const Text("Catégories de mesures")),
          floatingActionButton: FloatingActionButton(
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
            child: const Icon(Icons.edit),
          ),
          body: WrapperListview(
            isLoading: ctl.isLoading,
            onRefresh: ctl.getList,
            items: ctl.categoriesType,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (e, i) => ListTile(
              leading: CircleAvatar(
                child: SvgPicture.asset(
                  "assets/images/svg/categorie.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(e.categorieMesure?.libelle ?? 'Aucun nom'),
              trailing: IconButton(
                onPressed: () => ctl.delete(e.id.value),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
