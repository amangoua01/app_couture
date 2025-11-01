import 'package:app_couture/data/models/categorie_mesure.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';

class EditionCategoriePage extends StatelessWidget {
  final CategorieMesure? item;
  const EditionCategoriePage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter une catégorie")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          CTextFormField(externalLabel: "Libellé"),
          CButton(title: "Enregistrer"),
        ],
      ),
    );
  }
}
