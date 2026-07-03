import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/ligne_panier.dart';
import 'package:ateliya/tools/widgets/c_tab_bar.dart';
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
import 'package:flutter_animate/flutter_animate.dart';
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
              backgroundColor: Colors.grey.shade50,
              appBar: AppBar(
                title: const Text(
                  "Création de vente",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                elevation: 0,
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                              icon: const Icon(Icons.arrow_back_rounded),
                              onPressed: () {
                                tabController.animateTo(index - 1);
                              },
                              label: const Text('Précédent'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black87,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              body: Column(
                children: [
                  const CTabBar(
                    tabs: ["Informations", "Panier"],
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Onglet 1 : Informations
                        ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.grey.shade100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CDateFormField(
                                    controller: ctl.dateVenteCtl,
                                    externalLabel: "Date de vente",
                                    onChange: (d) {
                                      if (d != null) ctl.dateVenteCtl.date = d;
                                    },
                                  ),
                                  CDropDownFormField<Client>(
                                    externalLabel: "Client",
                                    require: true,
                                    items: (filter, props) => ctl.getClients(),
                                    onChanged: (val) {
                                      ctl.client = val;
                                      ctl.update();
                                    },
                                    itemAsString: (c) =>
                                        "${c.nomComplet} (${c.tel})",
                                    popupProps: const PopupProps.menu(
                                        showSearchBox: true),
                                    selectedItem: ctl.client,
                                    margin: EdgeInsets.zero,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final res = await Get.to(
                                          () => const EditionClientPage());
                                      if (res != null) {
                                        ctl.update();
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(
                                                    Icons
                                                        .add_circle_outline_rounded,
                                                    color: AppColors.primary,
                                                    size: 16),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Nouveau client',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  CDropDownFormField<String>(
                                    externalLabel: "Moyen de paiement",
                                    items: (filter, props) => ModePaiementEnum
                                        .values
                                        .map((e) => e.label)
                                        .toList(),
                                    selectedItem: ctl.moyenPaiement,
                                    onChanged: (val) {
                                      ctl.moyenPaiement =
                                          val ?? ModePaiementEnum.especes.label;
                                    },
                                    margin: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fade(duration: 300.ms)
                                .slideY(begin: 0.05, end: 0),
                          ],
                        ),

                        // Onglet 2 : Panier
                        Scaffold(
                          backgroundColor: Colors.grey.shade50,
                          floatingActionButton: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: FloatingActionButton.extended(
                              onPressed: () =>
                                  _showAddArticleSheet(context, ctl),
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.primary,
                              elevation: 4,
                              icon: const Icon(Icons.add_rounded, size: 22),
                              label: const Text(
                                "Ajouter article",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          body: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(20, 8, 20, 10),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0A3A30), // AppColors.primary
                                      Color(0xFF135346),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "TOTAL PANIER",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const Gap(6),
                                        Text(
                                          "${ctl.panier.length} article(s) sélectionné(s)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      ctl.totalGeneral.toAmount(unit: 'F'),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                  height: 1, color: Colors.transparent),
                              Expanded(
                                child: ctl.panier.isEmpty
                                    ? Center(
                                        child: SingleChildScrollView(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 60, horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border: Border.all(
                                                  color: Colors.grey.shade100),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.secondary
                                                        .withValues(alpha: 0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.shopping_bag_outlined,
                                                    color: AppColors.secondary,
                                                    size: 48,
                                                  ),
                                                ),
                                                const Gap(20),
                                                const Text(
                                                  "Votre panier est vide",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                                const Gap(8),
                                                Text(
                                                  "Parcourez vos articles et ajoutez-les pour créer la vente.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade500,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                              .animate()
                                              .fade(duration: 350.ms)
                                              .slideY(
                                                  begin: 0.05,
                                                  end: 0,
                                                  curve: Curves.easeOutCubic),
                                        ),
                                      )
                                    : WrapperListview(
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 8, 20, 100),
                                        itemBuilder: (_, i) {
                                          final item = ctl.panier[i];
                                          return _LignePanierCard(
                                            index: i,
                                            item: item,
                                            ctl: ctl,
                                            onEdit: () => _showAddArticleSheet(
                                                context, ctl,
                                                itemToEdit: item),
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
      text: itemToEdit?.prixUnitaire.value.toStringAsFixed(0),
    );
    final qteCtl =
        TextEditingController(text: (itemToEdit?.quantite ?? 1).toString());
    final remiseCtl = TextEditingController(
      text: itemToEdit?.remise.value.toStringAsFixed(0) ?? "0",
    );

    CBottomSheet.show(
      child: StatefulBuilder(builder: (context, setState) {
        double calculateTotal() {
          final prix = double.tryParse(prixCtl.text) ?? 0;
          final qte = int.tryParse(qteCtl.text) ?? 0;
          final remise = double.tryParse(remiseCtl.text) ?? 0;
          return (prix * qte) - remise;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                itemToEdit != null
                    ? "Modifier l'article"
                    : "Ajouter un article",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Gap(20),
              CDropDownFormField<ModeleBoutique>(
                externalLabel: "Modèle",
                items: (filter, props) => ctl.getModeles(),
                enabled: itemToEdit == null,
                selectedItem: selectedModele,
                itemAsString: (m) =>
                    "${m.modele?.libelle ?? ''}${m.taille?.isNotEmpty == true ? ' - ${m.taille}' : ''} (${m.prix.toAmount()})",
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected, b) {
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
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
                      title: Text(
                        "${item.modele?.libelle ?? ""}${item.taille?.isNotEmpty == true ? ' - ${item.taille}' : ''}",
                      ),
                      subtitle: Text(
                        "${item.prix.toAmount()} • Stocks: ${item.quantite}",
                      ),
                      selected: isSelected,
                    );
                  },
                ),
                onChanged: (val) {
                  setState(() {
                    selectedModele = val;
                    if (val != null && itemToEdit == null) {
                      prixCtl.text =
                          val.prix.toDouble().value.toStringAsFixed(0);
                    }
                  });
                },
              ),
              const Gap(15),
              Row(
                children: [
                  Expanded(
                    child: CTextFormField(
                      externalLabel: "Prix Unitaire",
                      hintText: selectedModele?.haveCommission == true
                          ? "[${selectedModele?.prixMinimal.toAmount() ?? 0}, ${selectedModele?.prixMax.toAmount() ?? 0}]"
                          : "Prix de vente",
                      controller: prixCtl,
                      enabled: selectedModele?.haveCommission == true,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: CTextFormField(
                      externalLabel: "Quantité",
                      controller: qteCtl,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: ctl.user.isAdmin,
                child: Column(
                  children: [
                    const Gap(15),
                    CTextFormField(
                      externalLabel: "Remise (sur le total)",
                      controller: remiseCtl,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total ligne",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      calculateTotal().toAmount(unit: 'F'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(30),
              CButton(
                title: itemToEdit != null ? "Modifier" : "Ajouter au panier",
                onPressed: () {
                  if (selectedModele != null) {
                    final prix = double.tryParse(prixCtl.text) ?? 0;
                    final qte = int.tryParse(qteCtl.text) ?? 1;
                    final remise = double.tryParse(remiseCtl.text) ?? 0;

                    if (qte > (selectedModele!.quantite ?? 0) &&
                        itemToEdit == null) {
                      CMessageDialog.show(
                          message:
                              "Stock insuffisant. Disponible : ${selectedModele!.quantite ?? 0}");
                      return;
                    }

                    if (selectedModele!.haveCommission == true) {
                      final pMin = selectedModele!.prixMinimal ?? 0;
                      final pMax = selectedModele!.prixMax ?? 0;
                      if (prix < pMin || prix > pMax) {
                        CMessageDialog.show(
                            message:
                                "Le prix unitaire doit être compris entre ${pMin.toAmount(unit: 'F')} et ${pMax.toAmount(unit: 'F')}");
                        return;
                      }
                    }

                    if (itemToEdit != null) {
                      ctl.modifierLignePanier(itemToEdit, qte, prix, remise);
                    } else {
                      ctl.ajouterAuPanier(selectedModele!, qte, prix, remise);
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
        );
      }),
    );
  }
}

class _LignePanierCard extends StatelessWidget {
  final int index;
  final LignePanier item;
  final EditionVenteMultiplePageVctl ctl;
  final VoidCallback onEdit;

  const _LignePanierCard({
    required this.index,
    required this.item,
    required this.ctl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: PlaceholderBuilder(
                        placeholder: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        condition:
                            (item.modele.modele?.photo is FichierServer) &&
                                (item.modele.modele?.photo as FichierServer)
                                        .fullUrl !=
                                    null,
                        builder: () => Image.network(
                          (item.modele.modele!.photo as FichierServer).fullUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.modele.modele?.libelle ?? ""}${item.modele.taille?.isNotEmpty == true ? ' - ${item.modele.taille}' : ''}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const Gap(6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Qté: ${item.quantite}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Gap(8),
                            Text(
                              item.prixUnitaire.toAmount(unit: 'F'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (item.remise > 0) ...[
                          const Gap(4),
                          Text(
                            "Remise: -${item.remise.toAmount(unit: 'F')}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.total.toAmount(unit: 'F'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const Gap(8),
                      GestureDetector(
                        onTap: () => ctl.retirerDuPanier(item),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: 250.ms)
        .slideX(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}
