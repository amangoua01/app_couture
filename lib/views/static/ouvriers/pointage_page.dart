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
                  for (var i = 0; i < lignes.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: CDropDownFormField<TypeMesure>(
                              margin: EdgeInsets.zero,
                              selectedItem: lignes[i].type,
                              items: (f, p) => ctl.typesMesure,
                              itemAsString: (t) => t.libelle ?? "",
                              hintText: "Type de pièce",
                              onChanged:
                                  (t) => setState(() => lignes[i].type = t),
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            flex: 2,
                            child: CTextFormField(
                              margin: EdgeInsets.zero,
                              hintText: "Qté",
                              controller: lignes[i].qteCtl,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                            onPressed:
                                () => setState(() => lignes.removeAt(i)),
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Gap(10),
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
