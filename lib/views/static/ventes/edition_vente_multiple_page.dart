import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/ventes/edition_vente_multiple_page_vctl.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionVenteMultiplePage extends StatelessWidget {
  const EditionVenteMultiplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditionVenteMultiplePageVctl>(
      init: EditionVenteMultiplePageVctl(),
      builder: (ctl) {
        return DefaultTabController(
          length: 2,
          child: Builder(builder: (context) {
            final tabController = DefaultTabController.of(context);
            return Scaffold(
              appBar: AppBar(
                title: const Text("Création de vente"),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Informations"),
                    Tab(text: "Panier"),
                  ],
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: tabController.animation!,
                    builder: (context, child) {
                      final index = tabController.index;
                      return Row(
                        children: [
                          if (index > 0)
                            TextButton.icon(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                tabController.animateTo(index - 1);
                              },
                              label: const Text('Précédent'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black87,
                              ),
                            ),
                          const Spacer(),
                          if (index < 1)
                            SizedBox(
                              width: 120,
                              child: CButton(
                                title: "Suivant",
                                onPressed: () {
                                  tabController.animateTo(index + 1);
                                },
                              ),
                            )
                          else
                            Expanded(
                              child: CButton(
                                title:
                                    "Valider (${ctl.totalGeneral.toAmount(unit: 'F')})",
                                onPressed: ctl.submit,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  // Onglet 1 : Informations
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      CDateFormField(
                        controller: ctl.dateVenteCtl,
                        externalLabel: "Date de vente",
                        onChange: (d) {
                          if (d != null) ctl.dateVenteCtl.date = d;
                        },
                      ),
                      const Gap(20),
                      CDropDownFormField<Client>(
                        externalLabel: "Client",
                        require: true,
                        items: (filter, props) => ctl.getClients(),
                        onChanged: (val) {
                          ctl.client = val;
                          ctl.update();
                        },
                        itemAsString: (c) => "${c.nomComplet} (${c.tel})",
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        selectedItem: ctl.client,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final res =
                              await Get.to(() => const EditionClientPage());
                          if (res != null) {
                            ctl.update();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.add,
                                  color: AppColors.primary, size: 18),
                              SizedBox(width: 4),
                              Text(
                                'Nouveau client',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(20),
                      CDropDownFormField<String>(
                        externalLabel: "Moyen de paiement",
                        items: (filter, props) => ModePaiementEnum.values
                            .map((e) => e.label)
                            .toList(),
                        selectedItem: ctl.moyenPaiement,
                        onChanged: (val) {
                          ctl.moyenPaiement =
                              val ?? ModePaiementEnum.especes.label;
                        },
                      ),
                    ],
                  ),

                  // Onglet 2 : Panier
                  Scaffold(
                    floatingActionButton: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: FloatingActionButton.extended(
                        onPressed: () => _showAddArticleSheet(context, ctl),
                        backgroundColor: AppColors.primary,
                        icon: const Icon(Icons.add),
                        label: const Text("Ajouter article"),
                      ),
                    ),
                    body: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: AppColors.primary.withValues(alpha: 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Panier",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ctl.totalGeneral.toAmount(unit: 'F'),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ctl.panier.isEmpty
                              ? const Center(
                                  child: Text("Votre panier est vide."))
                              : WrapperListview(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  itemBuilder: (_, i) {
                                    final item = ctl.panier[i];
                                    return ListTile(
                                      onTap: () => _showAddArticleSheet(
                                          context, ctl,
                                          itemToEdit: item),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: PlaceholderBuilder(
                                            placeholder:
                                                Center(child: Text("${i + 1}")),
                                            condition: (item.modele.modele
                                                    ?.photo is FichierServer) &&
                                                (item.modele.modele?.photo
                                                            as FichierServer)
                                                        .fullUrl !=
                                                    null,
                                            builder: () => Image.network(
                                              (item.modele.modele!.photo
                                                      as FichierServer)
                                                  .fullUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                          item.modele.modele?.libelle ?? ""),
                                      subtitle: Text(
                                          "${item.quantite} x ${item.prixUnitaire.toAmount(unit: '')}"),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.total.toAmount(unit: 'F'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                ctl.retirerDuPanier(item),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  items: ctl.panier,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  void _showAddArticleSheet(
      BuildContext context, EditionVenteMultiplePageVctl ctl,
      {LignePanier? itemToEdit}) {
    ModeleBoutique? selectedModele = itemToEdit?.modele;
    final prixCtl = TextEditingController(
        text: itemToEdit?.prixUnitaire.toDouble().value.toStringAsFixed(0));
    final qteCtl =
        TextEditingController(text: (itemToEdit?.quantite ?? 1).toString());

    CBottomSheet.show(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                itemToEdit != null
                    ? "Modifier l'article"
                    : "Ajouter un article",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Gap(20),
            CDropDownFormField<ModeleBoutique>(
              externalLabel: "Modèle",
              items: (filter, props) => ctl.getModeles(),
              enabled: itemToEdit == null,
              selectedItem: selectedModele,
              itemAsString: (m) =>
                  "${m.modele?.libelle ?? ''} (${m.prix.toAmount()})",
              popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected, b) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: PlaceholderBuilder(
                          placeholder: const Icon(Icons.image,
                              size: 20, color: Colors.grey),
                          condition: (item.modele?.photo is FichierServer) &&
                              (item.modele?.photo as FichierServer).fullUrl !=
                                  null,
                          builder: () => Image.network(
                            (item.modele!.photo as FichierServer).fullUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(item.modele?.libelle ?? ""),
                    subtitle: Text(
                        "${item.prix.toAmount()} • Stocks: ${item.quantite}"),
                    selected: isSelected,
                  );
                },
              ),
              onChanged: (val) {
                selectedModele = val;
                if (val != null && itemToEdit == null) {
                  prixCtl.text = val.prix.toDouble().value.toStringAsFixed(0);
                }
              },
            ),
            const Gap(15),
            Row(
              children: [
                Expanded(
                  child: CTextFormField(
                    externalLabel: "Prix Unitaire",
                    controller: prixCtl,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Gap(15),
                Expanded(
                  child: CTextFormField(
                    externalLabel: "Quantité",
                    controller: qteCtl,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Gap(30),
            CButton(
              title: itemToEdit != null ? "Modifier" : "Ajouter au panier",
              onPressed: () {
                if (selectedModele != null) {
                  final prix = double.tryParse(prixCtl.text) ?? 0;
                  final qte = int.tryParse(qteCtl.text) ?? 1;

                  if (qte > (selectedModele!.quantite ?? 0)) {
                    CMessageDialog.show(
                        message:
                            "Stock insuffisant. Disponible : ${selectedModele!.quantite ?? 0}");
                    return;
                  }

                  if (selectedModele!.prixMinimal != null &&
                      prix < selectedModele!.prixMinimal!) {
                    CMessageDialog.show(
                        message:
                            "Le prix ne peut être inférieur à ${selectedModele!.prixMinimal!.toAmount(unit: 'F')}");
                    return;
                  }

                  if (itemToEdit != null) {
                    ctl.modifierLignePanier(itemToEdit, qte, prix);
                  } else {
                    ctl.ajouterAuPanier(selectedModele!, qte, prix);
                  }
                  Get.back();
                } else {
                  CMessageDialog.show(
                      message: "Veuillez sélectionner un article");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
