import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:ateliya/views/static/mesure/sub_pages/edit_montant_piece_dialog.dart';
import 'package:flutter/material.dart';

class RecapSubPage extends StatelessWidget {
  final EditionMesurePageVctl ctl;
  const RecapSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Table(
          border: TableBorder.all(
            color: AppColors.primary,
            width: 1,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              children: ["Pièce", "Montant", "Remise", "Total"]
                  .map(
                    (e) => SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          e,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            ...ctl.mesure.lignesMesures.map(
              (e) => TableRow(
                children: [
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(e.typeMesureDto!.libelle),
                    ),
                  ),
                  // Montant et remise ouvrent le même dialogue d'édition
                  // rapide que sur l'écran de liste des pièces : pas besoin
                  // de rouvrir la fiche complète pour corriger un prix ici.
                  _EditableCell(
                    value: e.montant.toAmount(),
                    onTap: () => editMontantPiece(ctl, e),
                  ),
                  _EditableCell(
                    value: e.remise.toAmount(),
                    onTap: () => editMontantPiece(ctl, e),
                  ),
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(e.total.toAmount()),
                    ),
                  ),
                ],
              ),
            ),
            TableRow(
              decoration: BoxDecoration(
                color: Colors.green.shade50,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  child: const Center(
                    child: Text(
                      "Montant total",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("-"),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("-"),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      ctl.mesure.montantTotal.toAmount(),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(
                color: Colors.green.shade50,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  child: const Center(
                    child: Text(
                      "Remise globale",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("-"),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("-"),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      ctl.remiseGlobaleCtl.text.toAmount(),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(
                color: Colors.green.shade50,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  child: const Center(
                    child: Text(
                      "Avance",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("-"),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("-"),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      ctl.avanceCtl.text.toAmount(),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(
                color: Colors.green.shade200,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  child: const Center(
                    child: Text(
                      "Reste à payer",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("-"),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("-"),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      ctl.mesure
                          .resteArgent(
                            ctl.avanceCtl.toDouble(),
                            ctl.remiseGlobaleCtl.toDouble(),
                          )
                          .toAmount(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableCell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _EditableCell({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value),
                const SizedBox(width: 4),
                const Icon(
                  Icons.edit_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
