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
import 'package:ateliya/views/controllers/reservation/edition_reservation_vctl.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionReservationPage extends StatelessWidget {
  final ModeleBoutique modeleBoutique;
  const EditionReservationPage(this.modeleBoutique, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionReservationVctl(modeleBoutique),
      builder: (ctl) {
        final montant = ctl.montant;
        return Scaffold(
          appBar: AppBar(title: const Text('Nouvelle réservation')),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                ArticleCard(item: modeleBoutique),
                const Gap(22),
                const SectionTitre('Client'),
                CDropDownFormField<Client>(
                  selectedItem: ctl.client,
                  require: true,
                  hintText: 'Choisir le client',
                  margin: const EdgeInsets.only(bottom: 6),
                  items: (filter, _) => ctl.getClients(),
                  compareFn: (a, b) => a.id == b.id,
                  itemAsString: (c) => c.fullName,
                  filterFn: (client, filter) {
                    final q = filter.toLowerCase();
                    return (client.nom ?? '').toLowerCase().contains(q) ||
                        (client.prenom ?? '').toLowerCase().contains(q) ||
                        (client.tel ?? '').toLowerCase().contains(q);
                  },
                  popupProps: FieldPopup.bottomSheet<Client>(
                    title: 'Choisir un client',
                    searchHint: 'Nom, prénom ou téléphone…',
                    emptyLabel: 'Aucun client trouvé',
                    emptyHint: 'Créez-le avec « Nouveau client ».',
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
                    label: const Text('Nouveau client'),
                  ),
                ),
                const Gap(8),
                const SectionTitre('Réservation'),
                CDateFormField(
                  externalLabel: 'Date de retrait',
                  controller: ctl.dateRetraitCtl,
                  require: true,
                  firstDate: DateTime.now(),
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  onChange: (d) {
                    ctl.dateRetrait = d;
                    ctl.dateRetraitCtl.date = d;
                    ctl.update();
                  },
                ),
                CTextFormField(
                  controller: ctl.prixCtl,
                  externalLabel: 'Prix unitaire',
                  keyboardType: TextInputType.number,
                  require: true,
                  enabled: modeleBoutique.haveCommission == true,
                  onChanged: (_) => ctl.update(),
                  validator: (e) {
                    if (e == null || e.isEmpty) return 'Le prix est requis';
                    final prix = e.toDouble().value;
                    if (prix <= 0) return 'Le prix doit être supérieur à 0';
                    if (modeleBoutique.haveCommission == true) {
                      final pMin = modeleBoutique.prixMinimal ?? 0;
                      final pMax = modeleBoutique.prixMax ?? 0;
                      if (prix < pMin || prix > pMax) {
                        return 'Entre ${pMin.toAmount(unit: 'F')} et ${pMax.toAmount(unit: 'F')}';
                      }
                    }
                    return null;
                  },
                ),
                _Quantite(ctl: ctl),
                if (ctl.stockInsuffisant) _AvertissementStock(stock: ctl.stock),
                const Gap(14),
                const SectionTitre('Acompte'),
                CTextFormField(
                  controller: ctl.avanceCtl,
                  externalLabel: 'Montant versé maintenant',
                  keyboardType: TextInputType.number,
                  margin: const EdgeInsets.only(bottom: 10),
                  onChanged: (_) => ctl.update(),
                  validator: (e) {
                    final v = double.tryParse(e == null || e.isEmpty ? '0' : e);
                    if (v == null || v < 0) return 'Montant invalide';
                    if (v > ctl.montant) {
                      return 'Ne peut pas dépasser ${ctl.montant.toAmount(unit: 'F')}';
                    }
                    return null;
                  },
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    _Raccourci(
                      'Aucun',
                      actif: ctl.avance == 0,
                      onTap: () => ctl.definirAvance(0),
                    ),
                    _Raccourci(
                      '50 %',
                      actif:
                          montant > 0 &&
                          ctl.avance == (montant / 2).roundToDouble(),
                      onTap: () => ctl.definirAvance(montant / 2),
                    ),
                    _Raccourci(
                      'Total',
                      actif: montant > 0 && ctl.avance == montant,
                      onTap: () => ctl.definirAvance(montant),
                    ),
                  ],
                ),
                if (ctl.avance > 0) ...[
                  const Gap(18),
                  CDropDownFormField<String>(
                    externalLabel: 'Moyen de paiement',
                    require: true,
                    showClearButton: false,
                    margin: EdgeInsets.zero,
                    selectedItem: ctl.moyenPaiement,
                    items:
                        (f, p) =>
                            ModePaiementEnum.values
                                .map((e) => e.label)
                                .toList(),
                    popupProps: FieldPopup.bottomSheet<String>(
                      title: 'Moyen de paiement',
                      showSearchBox: false,
                      itemBuilder:
                          (_, label, __, isSelected) => PaiementTile(
                            label: label,
                            isSelected: isSelected,
                          ),
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        ctl.moyenPaiement = val;
                        ctl.update();
                      }
                    },
                  ),
                ],
                const Gap(20),
                _Recap(montant: montant, avance: ctl.avance),
                const Gap(20),
                CButton(
                  title: 'Enregistrer la réservation',
                  height: 54,
                  radius: 16,
                  fontWeight: FontWeight.w700,
                  icon: const Icon(
                    Icons.bookmark_added_outlined,
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

class _Quantite extends StatelessWidget {
  final EditionReservationVctl ctl;
  const _Quantite({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 3),
            child: Text('Quantité*', style: FieldBorder.labelStyle),
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
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  margin: EdgeInsets.zero,
                  onChanged: (_) => ctl.update(),
                  validator: (e) {
                    final qty = int.tryParse(e ?? '');
                    if (qty == null || qty <= 0) return 'Quantité invalide';
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

/// Réserver au-delà du stock reste possible : on le dit, sans bloquer.
class _AvertissementStock extends StatelessWidget {
  final int stock;
  const _AvertissementStock({required this.stock});

  @override
  Widget build(BuildContext context) {
    const couleur = Color(0xFFC2410C);
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: couleur),
          const Gap(10),
          Expanded(
            child: Text(
              'Stock disponible : $stock. La réservation sera enregistrée « en attente de stock » et ne pourra être confirmée qu\'après ravitaillement.',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: couleur,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Raccourci extends StatelessWidget {
  final String label;
  final bool actif;
  final VoidCallback onTap;
  const _Raccourci(this.label, {required this.actif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: actif,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.5,
        color: actif ? Colors.white : AppColors.primary,
      ),
    );
  }
}

class _Recap extends StatelessWidget {
  final double montant;
  final double avance;
  const _Recap({required this.montant, required this.avance});

  @override
  Widget build(BuildContext context) {
    final reste = montant - avance;
    Widget ligne(String l, String v, {bool fort = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l,
              style: TextStyle(
                fontSize: fort ? 14.5 : 13,
                fontWeight: fort ? FontWeight.w800 : FontWeight.w500,
                color: fort ? AppColors.primary : Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            v,
            style: TextStyle(
              fontSize: fort ? 18 : 14,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ligne('Montant total', montant.toAmount(unit: 'F')),
          ligne('Acompte', avance.toAmount(unit: 'F')),
          const Divider(height: 18),
          ligne('Reste à payer', reste.toAmount(unit: 'F'), fort: true),
        ],
      ),
    );
  }
}
