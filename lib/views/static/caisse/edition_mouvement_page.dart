import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/caisse/approvisionner_caisse_page_vctl.dart';
// import 'package:ateliya/views/controllers/caisse/approvisionner_caisse_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovisionnerCaissePage extends StatelessWidget {
  const ApprovisionnerCaissePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ApprovisionnerCaissePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Approvisionner caisse")),
          body: Form(
            key: ctl.formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CTextFormField(
                    externalLabel: "Description",
                    controller: ctl.descriptionCtl,
                    maxLines: 3,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: ctl.lines.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final line = ctl.lines[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ligne ${index + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (ctl.lines.length > 1)
                                  IconButton(
                                    onPressed: () => ctl.removeLine(index),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            CDropDownFormField<Caisse>(
                              externalLabel: "Caisse",
                              require: true,
                              selectedItem: line.caisse,
                              onChanged: (e) {
                                line.caisse = e;
                                ctl.update();
                              },
                              items: (filter, loadProps) => ctl.getCaisses(),
                              itemAsString: (item) =>
                                  "${item.reference} (${item.montant?.toAmount(unit: 'F')})",
                            ),
                            CTextFormField(
                              externalLabel: "Montant",
                              controller: line.montantCtl,
                              require: true,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total :",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ctl.totalMontant.toString().toAmount(unit: "F"),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: ctl.addLine,
                        icon: const Icon(Icons.add),
                        label: const Text("Ajouter une ligne"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: ctl.submit,
                        child: const Text("Enregistrer"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
