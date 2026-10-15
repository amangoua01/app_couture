import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/components/field_border.dart';
import 'package:ateliya/tools/components/field_popup.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/vente_widgets.dart';
import 'package:ateliya/views/controllers/ventes/edition_vente_page_vctl.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
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
        final total = ctl.total;
        return Scaffold(
          appBar: AppBar(title: const Text("Nouvelle vente")),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                ArticleCard(item: modeleBoutique),
                const Gap(22),
                const SectionTitre("Client"),
                CDropDownFormField<Client>(
                  selectedItem: ctl.client,
                  hintText: "Client de passage (facultatif)",
                  margin: const EdgeInsets.only(bottom: 6),
                  items: (filter, _) => ctl.getClients(),
                  compareFn: (a, b) => a.id == b.id,
                  itemAsString: (c) => c.fullName,
                  filterFn: (client, filter) {
                    // Recherche par nom, prénom ou téléphone.
                    final q = filter.toLowerCase();
                    return (client.nom ?? '').toLowerCase().contains(q) ||
                        (client.prenom ?? '').toLowerCase().contains(q) ||
                        (client.tel ?? '').toLowerCase().contains(q);
                  },
                  popupProps: FieldPopup.bottomSheet<Client>(
                    title: "Choisir un client",
                    searchHint: "Nom, prénom ou téléphone…",
                    emptyLabel: "Aucun client trouvé",
                    emptyHint:
                        "Vous pouvez en créer un avec « Nouveau client ».",
                    itemBuilder:
                        (_, client, __, isSelected) =>
                            ClientTile(client: client, isSelected: isSelected),
                  ),
                  onChanged: (e) {
                    ctl.client = e;
                    ctl.update();
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () async {
                      final created = await Get.to(
                        () => const EditionClientPage(),
                      );
                      if (created is Client) ctl.onClientCreated(created);
                    },
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text("Nouveau client"),
                  ),
                ),
                const Gap(8),
                const SectionTitre("Détails de la vente"),
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
                CTextFormField(
                  controller: ctl.prixCtl,
                  externalLabel: "Prix unitaire",
                  keyboardType: TextInputType.number,
                  require: true,
                  enabled: ctl.modeleBoutique.haveCommission == true,
                  onChanged: (_) => ctl.update(),
                  hintText:
                      ctl.modeleBoutique.haveCommission == true
                          ? "[${ctl.modeleBoutique.prixMinimal.toAmount(unit: "F")}, ${ctl.modeleBoutique.prixMax.toAmount(unit: "F")}]"
                          : "Prix de vente",
                  validator: (e) {
                    if (e == null || e.isEmpty) {
                      return "Le prix est requis";
                    }
                    final prix = e.toDouble().value;
                    if (ctl.modeleBoutique.haveCommission == true) {
                      final pMin = ctl.modeleBoutique.prixMinimal ?? 0;
                      final pMax = ctl.modeleBoutique.prixMax ?? 0;
                      if (prix < pMin || prix > pMax) {
                        return "Le prix doit être compris entre ${pMin.toAmount(unit: 'F')} et ${pMax.toAmount(unit: 'F')}";
                      }
                    } else if (prix < ctl.modeleBoutique.prixMinimal.value) {
                      return "Le prix doit être > ou = à ${ctl.modeleBoutique.prixMinimal.toAmount(unit: "F")}";
                    }
                    return null;
                  },
                ),
                _QuantiteField(ctl: ctl),
                CDropDownFormField<String>(
                  externalLabel: "Moyen de paiement",
                  require: true,
                  showClearButton: false,
                  selectedItem: ctl.moyenPaiement,
                  items:
                      (f, p) =>
                          ModePaiementEnum.values.map((e) => e.label).toList(),
                  popupProps: FieldPopup.bottomSheet<String>(
                    title: "Moyen de paiement",
                    showSearchBox: false,
                    itemBuilder:
                        (_, label, __, isSelected) =>
                            PaiementTile(label: label, isSelected: isSelected),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      ctl.moyenPaiement = val;
                      ctl.update();
                    }
                  },
                ),
                const Gap(6),
                _TotalCard(
                  quantite: ctl.quantite,
                  prix: ctl.prixUnitaire,
                  total: total,
                ),
                const Gap(20),
                CButton(
                  title: "Valider la vente · ${total.toAmount(unit: 'F')}",
                  height: 54,
                  radius: 16,
                  fontWeight: FontWeight.w700,
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: ctl.submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Composants ────────────────────────────────────────────────────────────────

/// Quantité avec boutons − et + : plus rapide que le clavier pour 1 à 3
/// pièces, et bornée au stock disponible.
class _QuantiteField extends StatelessWidget {
  final EditionVentePageVctl ctl;
  const _QuantiteField({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final stock = ctl.stock;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 3),
            child: Text("Quantité*", style: FieldBorder.labelStyle),
          ),
          Row(
            children: [
              PasBouton(
                icon: Icons.remove_rounded,
                onTap: () => ctl.changeQuantite(-1),
              ),
              const Gap(10),
              Expanded(
                child: CTextFormField(
                  controller: ctl.quantiteCtl,
                  hintText: 'Disponible : $stock',
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  margin: EdgeInsets.zero,
                  onChanged: (_) => ctl.update(),
                  validator: (e) {
                    if (e == null || e.isEmpty)
                      return 'La quantité est requise';
                    final qty = int.tryParse(e);
                    if (qty == null || qty <= 0) {
                      return 'Veuillez saisir une quantité valide';
                    }
                    if (qty > stock) {
                      return 'Stock insuffisant — disponible : $stock';
                    }
                    return null;
                  },
                ),
              ),
              const Gap(10),
              PasBouton(
                icon: Icons.add_rounded,
                onTap: () => ctl.changeQuantite(1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final int quantite;
  final double prix;
  final double total;
  const _TotalCard({
    required this.quantite,
    required this.prix,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$quantite × ${prix.toAmount(unit: 'F')}",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
          Text(
            total.toAmount(unit: 'F'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
