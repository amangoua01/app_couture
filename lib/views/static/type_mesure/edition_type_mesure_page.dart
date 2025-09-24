import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/empty_data_widget.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/tools/widgets/placeholder_widget.dart';
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
                const CTextFormField(externalLabel: "Libellé"),
                const Gap(20),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Text("Type de mesure"),
                      Gap(20),
                      Expanded(child: Divider(color: AppColors.green)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () => CBottomSheet.show(
                        child: ListView.builder(
                          itemBuilder: (_, i) => CheckboxListTile(
                            title: const Text("Tour de manche"),
                            value: false,
                            onChanged: (e) {},
                          ),
                        ),
                      ),
                      label: const Text("Ajouter catégorie"),
                    )
                  ],
                ),
                PlaceholderWidget(
                  condition: true,
                  placeholder: const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: EmptyDataWidget(),
                  ),
                  child: Wrap(
                    spacing: 10,
                    // runSpacing: 10,
                    children: List.generate(
                      10,
                      (i) => Chip(
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
