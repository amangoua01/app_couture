import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/info_title.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditionCategorieTypeMesureSubPage extends StatefulWidget {
  final List<int> selectedCategoriesIds;
  final List<CategorieMesure> categories;
  final void Function(List<CategorieMesure>) onSaved;

  const EditionCategorieTypeMesureSubPage({
    super.key,
    required this.selectedCategoriesIds,
    required this.categories,
    required this.onSaved,
  });

  @override
  State<EditionCategorieTypeMesureSubPage> createState() =>
      _EditionCategorieTypeMesureSubPageState();
}

class _EditionCategorieTypeMesureSubPageState
    extends State<EditionCategorieTypeMesureSubPage> {
  final List<CategorieMesure> newCategories = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const InfoTitle(
          text: "Sélectionnez les catégories de mesures"
              " à ajouter au type de mesure.",
          textSize: 15,
          padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 15),
        ),
        Expanded(
          child: WrapperListview(
            items: widget.categories,
            itemBuilder: (e, i) => CheckboxListTile(
              value: newCategories.any((c) => c.id.value == e.id.value) ||
                  widget.selectedCategoriesIds.contains(e.id.value),
              enabled: !widget.selectedCategoriesIds.contains(e.id.value),
              onChanged: (value) {
                setState(() {
                  if (value == false) {
                    newCategories.removeWhere((c) => c.id.value == e.id.value);
                  } else {
                    newCategories.add(CategorieMesure(
                      id: e.id,
                      libelle: e.libelle,
                    ));
                  }
                });
              },
              secondary: CircleAvatar(
                child: SvgPicture.asset(
                  "assets/images/svg/categorie.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(e.libelle.value),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: CButton(
            onPressed: () => widget.onSaved(newCategories),
            title: "Enregistrer",
          ),
        ),
      ],
    );
  }
}
