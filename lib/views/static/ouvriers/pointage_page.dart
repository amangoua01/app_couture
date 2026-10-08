import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/data/models/pointage_ligne.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/controllers/ouvriers/atelier_scope.dart';
import 'package:ateliya/views/controllers/ouvriers/pointage_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PointagePage extends StatelessWidget {
  const PointagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PointagePageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Pointage du ${ctl.dateJour}",
          subtitle: mentionAtelierActif(ctl.getEntite().value),
          withCreateButton: false,
          itemBuilder: (_, i, selected) {
            final employe = ctl.data.items[i];
            final pointage = ctl.pointagesDuJour[employe.id];
            final nbPieces = pointage?.piecesTerminees ?? 0;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: CardStyle.decoration(),
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openPointageSheet(context, ctl, employe),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.08,
                          ),
                          child: const Icon(
                            Icons.engineering_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employe.nomComplet ??
                                    employe.nom ??
                                    "Sans nom",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  _TimeChip(
                                    icon: Icons.login_rounded,
                                    value: pointage?.arrivee,
                                  ),
                                  const Gap(6),
                                  _TimeChip(
                                    icon: Icons.logout_rounded,
                                    value: pointage?.depart,
                                  ),
                                  if (nbPieces > 0) ...[
                                    const Gap(6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      child: Text(
                                        "$nbPieces pièce${nbPieces > 1 ? 's' : ''}",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openPointageSheet(
    BuildContext context,
    PointagePageVctl ctl,
    Employe employe,
  ) {
    final existing = ctl.pointagesDuJour[employe.id];
    String? arrivee = existing?.arrivee;
    String? depart = existing?.depart;
    final observationCtl = TextEditingController(text: existing?.observation);
    TypeMesure? findType(int? id) {
      if (id == null) return null;
      for (final t in ctl.typesMesure) {
        if (t.id == id) return t;
      }
      return null;
    }

    final lignes = <_LigneDraft>[
      for (final l in existing?.lignes ?? <PointageLigne>[])
        _LigneDraft(
          type: findType(l.typeMesureId),
          qteCtl: TextEditingController(text: l.quantite.toString()),
        ),
    ];
    bool isSubmitting = false;

    CBottomSheet.show(
      isScrollControlled: true,
      child: StatefulBuilder(
        builder: (sheetContext, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    employe.nomComplet ?? employe.nom ?? "Sans nom",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const Gap(18),
                  Row(
                    children: [
                      Expanded(
                        child: _TimeButton(
                          label: "Arrivée",
                          time: arrivee,
                          onPick: (t) => setState(() => arrivee = t),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: _TimeButton(
                          label: "Départ",
                          time: depart,
                          onPick: (t) => setState(() => depart = t),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pièces produites",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextButton.icon(
                        onPressed:
                            () => setState(
                              () => lignes.add(
                                _LigneDraft(qteCtl: TextEditingController()),
                              ),
                            ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Ajouter"),
                      ),
                    ],
                  ),
                  const Gap(4),
                  if (lignes.isEmpty)
                    _AucunePiece(
                      onAjouter: () => setState(
                        () => lignes.add(
                          _LigneDraft(qteCtl: TextEditingController()),
                        ),
                      ),
                    )
                  else
                    for (var i = 0; i < lignes.length; i++)
                      _CartePiece(
                        ligne: lignes[i],
                        types: ctl.typesMesure,
                        onTypeChange: (t) => setState(() => lignes[i].type = t),
                        onQuantiteChange: () => setState(() {}),
                        onSupprimer: () => setState(() => lignes.removeAt(i)),
                      ),
                  const Gap(14),
                  CTextFormField(
                    externalLabel: "Observation",
                    controller: observationCtl,
                    maxLines: 2,
                  ),
                  const Gap(20),
                  CButton(
                    title: "Enregistrer",
                    isLoading: isSubmitting,
                    onPressed: () async {
                      setState(() => isSubmitting = true);
                      final pointageLignes =
                          lignes
                              .where(
                                (l) =>
                                    l.type != null &&
                                    (int.tryParse(l.qteCtl.text) ?? 0) > 0,
                              )
                              .map(
                                (l) => PointageLigne(
                                  typeMesureId: l.type!.id,
                                  typeMesureLibelle: l.type!.libelle,
                                  quantite: int.parse(l.qteCtl.text),
                                ),
                              )
                              .toList();
                      final ok = await ctl.savePointage(
                        employe,
                        arrivee: arrivee,
                        depart: depart,
                        lignes: pointageLignes,
                        observation:
                            observationCtl.text.trim().isEmpty
                                ? null
                                : observationCtl.text.trim(),
                      );
                      setState(() => isSubmitting = false);
                      if (ok) Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LigneDraft {
  TypeMesure? type;
  final TextEditingController qteCtl;
  _LigneDraft({this.type, required this.qteCtl});
}

/// Une pièce produite et sa quantité.
///
/// L'ancienne présentation alignait un select, un champ « Qté » et une croix
/// de suppression sur une même ligne. Le select portait lui-même sa propre
/// croix d'effacement : deux croix voisines aux effets différents, dans un
/// alignement serré où la quantité se saisissait au clavier. On regroupe donc
/// chaque pièce dans sa carte, avec un compteur à boutons — plus rapide au
/// doigt que le clavier pour les petites quantités d'un pointage.
class _CartePiece extends StatelessWidget {
  final _LigneDraft ligne;
  final List<TypeMesure> types;
  final ValueChanged<TypeMesure?> onTypeChange;
  final VoidCallback onQuantiteChange;
  final VoidCallback onSupprimer;

  const _CartePiece({
    required this.ligne,
    required this.types,
    required this.onTypeChange,
    required this.onQuantiteChange,
    required this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CDropDownFormField<TypeMesure>(
                  margin: EdgeInsets.zero,
                  selectedItem: ligne.type,
                  items: (f, p) => types,
                  itemAsString: (t) => t.libelle ?? "",
                  hintText: "Type de pièce",
                  // La carte a déjà son bouton de suppression : une croix
                  // d'effacement de plus serait ambiguë.
                  showClearButton: false,
                  onChanged: onTypeChange,
                ),
              ),
              const Gap(4),
              IconButton(
                onPressed: onSupprimer,
                tooltip: "Retirer cette pièce",
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: Colors.red.shade300,
                ),
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Text(
                "Quantité",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              _CompteurQuantite(
                controller: ligne.qteCtl,
                onChanged: onQuantiteChange,
              ),
              const Gap(4),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compteur « − valeur + », la valeur restant saisissable au clavier pour les
/// grands nombres.
class _CompteurQuantite extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _CompteurQuantite({required this.controller, required this.onChanged});

  int get _valeur => int.tryParse(controller.text.trim()) ?? 0;

  void _appliquer(int nouvelle) {
    final valeur = nouvelle < 0 ? 0 : nouvelle;
    controller.text = valeur.toString();
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BoutonPas(
            icon: Icons.remove_rounded,
            // Rien à retirer à zéro : le bouton s'éteint plutôt que de
            // laisser croire à une action possible.
            onTap: _valeur > 0 ? () => _appliquer(_valeur - 1) : null,
          ),
          SizedBox(
            width: 46,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (_) => onChanged(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                hintText: "0",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          _BoutonPas(
            icon: Icons.add_rounded,
            onTap: () => _appliquer(_valeur + 1),
          ),
        ],
      ),
    );
  }
}

class _BoutonPas extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _BoutonPas({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final actif = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 19,
            color: actif
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}

/// Invite affichée quand aucune pièce n'a encore été saisie.
class _AucunePiece extends StatelessWidget {
  final VoidCallback onAjouter;
  const _AucunePiece({required this.onAjouter});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onAjouter,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.checkroom_rounded,
                size: 26,
                color: Colors.grey.shade400,
              ),
              const Gap(8),
              Text(
                "Aucune pièce enregistrée",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const Gap(2),
              Text(
                "Touchez pour en ajouter une",
                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final IconData icon;
  final String? value;
  const _TimeChip({required this.icon, this.value});

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: hasValue ? AppColors.primary : Colors.grey.shade400,
        ),
        const Gap(3),
        Text(
          value ?? "--:--",
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: hasValue ? AppColors.primary : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final String? time;
  final void Function(String) onPick;
  const _TimeButton({required this.label, this.time, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final hasValue = time != null;
    return OutlinedButton.icon(
      icon: const Icon(Icons.access_time, size: 16),
      label: Text(time ?? label),
      style: OutlinedButton.styleFrom(
        backgroundColor:
            hasValue ? AppColors.primary.withValues(alpha: 0.08) : null,
        foregroundColor: hasValue ? AppColors.primary : Colors.grey.shade700,
        side: BorderSide(
          color: hasValue ? AppColors.primary : Colors.grey.shade300,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: () async {
        final TimeOfDay? t = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (t != null) {
          onPick(
            "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}",
          );
        }
      },
    );
  }
}
