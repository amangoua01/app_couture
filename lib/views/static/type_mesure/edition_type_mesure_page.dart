import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/empty_data_widget.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/tools/widgets/placeholder_widget.dart';
import 'package:app_couture/tools/widgets/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditionTypeMesurePage extends StatelessWidget {
  const EditionTypeMesurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un type de mesure")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const TextDivider("Info type de mesure"),
                const CTextFormField(externalLabel: "Nom du type"),
                const Gap(20),
                const TextDivider("Catégories"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () => CBottomSheet.show(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 20, left: 10),
                              child: Text(
                                "Sélectionnez une catégorie",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (_, i) => CheckboxListTile(
                                  title: const Text("Tour de manche"),
                                  value: false,
                                  onChanged: (e) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      label: const Text("Ajouter catégorie"),
                    )
                  ],
                ),
                PlaceholderWidget(
                  condition: true,
                  placeholder: const EmptyDataWidget(),
                  child: GridView(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 4,
                    ),
                    // runSpacing: 10,
                    children: List.generate(
                      17,
                      (i) => Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: const Text("Tour de manche"),
                        onDeleted: () {},
                        deleteIconColor: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CButton(title: "Enregistrer"),
            ),
          ),
        ],
      ),
    );
  }
}
