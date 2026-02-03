import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/ventes/edition_vente_page_vctl.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionVentePage extends StatelessWidget {
  final ModeleBoutique modeleBoutique;
  const EditionVentePage(this.modeleBoutique, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionVentePageVctl(modeleBoutique),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Création de vente")),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // PlaceholderBuilder(
                //   condition: (ctl.setEntite is Boutique) == false,
                //   builder: () => CDropDownFormField(
                //     externalLabel: "Boutique",
                //     require: true,
                //     selectedItem: ctl.boutique,
                //     itemAsString: (e) => e.libelle.value,
                //     items: (p0, p1) => ctl.getBoutique(),
                //     onChanged: (e) {
                //       ctl.boutique = e;
                //       ctl.update();
                //     },
                //   ),
                // ),
                CDropDownFormField(
                  externalLabel: "Article",
                  require: true,
                  selectedItem: modeleBoutique,
                  itemAsString: (e) => e.modele!.libelle.value,
                  enabled: false,
                ),
                CDateFormField(
                  labelText: "Date de vente",
                  controller: ctl.dateVenteCtl,
                  withTime: true,
                  onChange: (e) {
                    ctl.dateVenteCtl.dateTime = e;
                    ctl.update();
                  },
                  require: true,
                ),
                CDropDownFormField<Client>(
                  externalLabel: "Client",
                  selectedItem: ctl.client,
                  items: (p0, p1) => ctl.getClients(),
                  require: true,
                  itemAsString: (p0) => "${p0.fullName} (${p0.tel.value})",
                  filterFn: (client, filter) {
                    // Recherche par nom, prénom ou téléphone
                    final searchTerm = filter.toLowerCase();
                    final nom = (client.nom ?? '').toLowerCase();
                    final prenom = (client.prenom ?? '').toLowerCase();
                    final tel = (client.tel ?? '').toLowerCase();

                    return nom.contains(searchTerm) ||
                        prenom.contains(searchTerm) ||
                        tel.contains(searchTerm);
                  },
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Rechercher par nom, prénom ou téléphone...",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  onChanged: (e) {
                    ctl.client = e;
                    ctl.update();
                  },
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const EditionClientPage()),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Text(
                        'Ajouter un client',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                CTextFormField(
                  controller: ctl.prixCtl,
                  externalLabel: "Prix unitaire",
                  keyboardType: TextInputType.number,
                  require: true,
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Le prix est requis";
                    } else {
                      if (e.toDouble().value <
                          ctl.modeleBoutique.prixMinimal.value) {
                        return "Le prix doit être > ou = à ${ctl.modeleBoutique.prixMinimal.toAmount(unit: "F")}";
                      }
                      return null;
                    }
                  },
                ),
                CTextFormField(
                  controller: ctl.quantiteCtl,
                  externalLabel: "Quantité",
                  require: true,
                ),
                CDropDownFormField(
                  externalLabel: "Moyen de paiement",
                  require: true,
                  selectedItem: ctl.moyenPaiement,
                  items: (f, p) =>
                      ModePaiementEnum.values.map((e) => e.label).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ctl.moyenPaiement = val;
                      ctl.update();
                    }
                  },
                ),
                const Gap(30),
                CButton(onPressed: ctl.submit),
              ],
            ),
          ),
        );
      },
    );
  }
}
