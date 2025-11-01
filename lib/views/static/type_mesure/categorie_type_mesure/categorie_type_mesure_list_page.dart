import 'package:app_couture/data/models/categorie_type_mesure.dart';
import 'package:app_couture/data/models/type_mesure.dart';
import 'package:app_couture/tools/extensions/types/int.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/wrapper_listview.dart';
import 'package:app_couture/views/controllers/type_mesure/categorie_type_mesure/categorie_type_mesure_list_vctl.dart';
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
          body: Column(
            children: [
              Expanded(
                child: WrapperListview(
                  isLoading: ctl.isLoading,
                  onRefresh: ctl.loadData,
                  items: ctl.categories,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (_, i) => CheckboxListTile(
                    value: ctl.isSelected(ctl.categories[i].id.value),
                    secondary: CircleAvatar(
                      child: SvgPicture.asset(
                        "assets/images/svg/categorie.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    title: Text(ctl.categories[i].libelle.value),
                    onChanged: (value) {
                      if (ctl.isSelected(ctl.categories[i].id.value)) {
                        ctl.categoriesType.removeWhere(
                          (e) =>
                              e.categorieMesure?.id ==
                              ctl.categories[i].id.value,
                        );
                        ctl.added.removeWhere(
                          (e) =>
                              e.categorieMesure?.id ==
                              ctl.categories[i].id.value,
                        );
                      } else {
                        ctl.added.add(
                          CategorieTypeMesure(
                            id: null,
                            categorieMesure: ctl.categories[i],
                          ),
                        );
                      }
                      ctl.update();
                    },
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: CButton(
                    enabled: ctl.added.isNotEmpty || ctl.deleted.isNotEmpty,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
