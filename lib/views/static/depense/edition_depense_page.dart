import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/depense/edition_depense_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionDepensePage extends StatelessWidget {
  const EditionDepensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionDepensePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Nouvelle dépense"),
          ),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CDropDownFormField<FamilleDepense>(
                  selectedItem: ctl.selectedFamille,
                  onChanged: (e) {
                    ctl.selectedFamille = e;
                    ctl.update();
                  },
                  items: (p0, p1) => ctl.getFamilles(),
                  itemAsString: (p0) => p0.libelle.value,
                  externalLabel: "Famille de dépense",
                  require: true,
                ),
                CTextFormField(
                  controller: ctl.montantCtl,
                  keyboardType: TextInputType.number,
                  externalLabel: 'Montant Total',
                  require: true,
                  suffix: const Text("FCFA"),
                ),
                const Gap(10),
                if (ctl.totalMontant > 0) ...[
                  LinearProgressIndicator(
                    value: ctl.progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ctl.progress == 1.0 ? Colors.green : Colors.orange,
                    ),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const Gap(5),
                  Text(
                    "Montant couvert: ${ctl.totalLignes.toInt()} / ${ctl.totalMontant.toInt()} FCFA (${(ctl.progress * 100).toStringAsFixed(1)}%)",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
                const Gap(20),
                const Text("Modes de règlement",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Gap(10),
                Column(
                  children: ctl.ligneRows.asMap().entries.map((entry) {
                    final index = entry.key;
                    final row = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CDropDownFormField<Caisse>(
                              selectedItem: row.caisse,
                              onChanged: (e) {
                                row.caisse = e;
                                ctl.update();
                              },
                              items: (p0, p1) => ctl.getCaissesHelper(),
                              itemAsString: (p0) =>
                                  "${p0.entite?.libelle} (${p0.type ?? 'Caisse'}) : ${p0.montant} FCFA",
                              externalLabel: "Caisse",
                              require: true,
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            flex: 1,
                            child: CTextFormField(
                              controller: row.montantCtl,
                              keyboardType: TextInputType.number,
                              externalLabel: 'Montant',
                              require: true,
                              enabled: row.caisse != null,
                              onChanged: (val) {
                                // Maybe live validation here? Not strictly required but good UX.
                              },
                            ),
                          ),
                          if (ctl.ligneRows.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => ctl.removeLigne(index),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: ctl.addLigne,
                    icon: const Icon(Icons.add),
                    label: const Text("Ajouter une ligne"),
                  ),
                ),
                CTextFormField(
                  controller: ctl.descriptionCtl,
                  externalLabel: "Description",
                  maxLines: 3,
                ),
                const Gap(20),
                CButton(
                  onPressed: ctl.submit,
                  title: "Enregistrer",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
