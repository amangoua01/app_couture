import 'package:ateliya/views/static/mesure/sub_pages/gemini_mesure_sheet.dart';
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:ateliya/views/static/mesure/edition_piece_couture_page.dart';
import 'package:ateliya/views/static/mesure/sub_pages/edit_montant_piece_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ListPieceSubPage extends StatelessWidget {
  final EditionMesurePageVctl ctl;
  const ListPieceSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'voice',
            backgroundColor: const Color(0xFFDC2626),
            icon: const Icon(Icons.mic, color: Colors.white),
            label: const Text(
              "Vocal",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed:
                () => GeminiMesureSheet.show(
                  context,
                  onPieceAdded: (res) {
                    ctl.mesure.lignesMesures.add(res);
                    ctl.update();
                  },
                ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            heroTag: 'add',
            onPressed: () async {
              final res = await Get.to(() => const EditionPieceCouturePage());
              if (res is LigneMesureDto) {
                ctl.mesure.lignesMesures.add(res);
                ctl.update();
              }
            },
            backgroundColor: AppColors.primary,
            elevation: 4,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text(
              "Ajouter",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: WrapperListview(
        items: ctl.mesure.lignesMesures,
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        emptyWidget: _EmptyPiecesState(ctl: ctl),
        itemBuilder: (e, index) {
          final valideMensurations =
              e.typeMesureDto?.mensurations
                  .where(
                    (m) => m.isActive && m.valeur.isNotEmpty && m.valeur != "0",
                  )
                  .toList() ??
              [];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  final res = await Get.to(
                    () => EditionPieceCouturePage(ligne: e),
                  );
                  if (res is LigneMesureDto) {
                    ctl.mesure.lignesMesures[index] = res;
                    ctl.update();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header of Card
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.checkroom_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.libelle,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  e.typeMesureDto == null
                                      ? "Aucun modèle"
                                      : "Modèle : ${e.typeMesureDto!.libelle}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Delete button
                          IconButton(
                            onPressed: () async {
                              final rep = await CChoiceMessageDialog.show(
                                message:
                                    "Voulez-vous vraiment supprimer cette pièce ?",
                              );
                              if (rep == true) {
                                ctl.mesure.lignesMesures.remove(e);
                                ctl.update();
                              }
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.withAlpha(15),
                              padding: const EdgeInsets.all(8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),

                      // Montant — rangée pleine largeur, nettement plus
                      // facile à viser que l'ancienne puce étroite (dont la
                      // petite zone tappable se confondait avec le tap de
                      // toute la carte, qui ouvre la fiche complète).
                      const Gap(16),
                      Material(
                        color: Colors.green.withAlpha(15),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => editMontantPiece(ctl, e),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.payments_outlined,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const Gap(8),
                                Expanded(
                                  child: Text(
                                    "Montant : ${e.getCalcul}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.edit_rounded,
                                  size: 15,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Gap(16),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const Gap(12),

                      // Mensurations : grille 2 colonnes à largeur fixe —
                      // plus de libellés qui débordent sur deux lignes
                      // comme avec l'ancien Wrap. Le bouton "Mesurer" a été
                      // retiré : toute la carte ouvre déjà la fiche complète
                      // de la pièce au tap, ce bouton faisait doublon.
                      PlaceholderBuilder(
                        condition: e.tailleStandard != null,
                        placeholder:
                            valideMensurations.isEmpty
                                ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "Aucune mensuration renseignée",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                )
                                : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 6,
                                        crossAxisSpacing: 6,
                                        childAspectRatio: 3.4,
                                      ),
                                  itemCount: valideMensurations.length,
                                  itemBuilder: (_, i) {
                                    final m = valideMensurations[i];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              m.categorieMesure.libelle ?? '',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const Gap(4),
                                          Text(
                                            m.valeur,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        builder: () {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Taille standard : ${e.tailleStandard?.libelle}",
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// État vide propre à cet écran : les deux façons d'ajouter une pièce sont
/// proposées directement dans le corps, pas seulement via les boutons
/// flottants — plus accueillant qu'une illustration générique isolée.
class _EmptyPiecesState extends StatelessWidget {
  final EditionMesurePageVctl ctl;
  const _EmptyPiecesState({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
              ),
              child: const Icon(
                Icons.checkroom_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const Gap(20),
            const Text(
              "Aucune pièce ajoutée",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const Gap(8),
            const Text(
              "Ajoutez une pièce manuellement, ou dictez ses mensurations à voix haute.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const Gap(28),
            Row(
              children: [
                Expanded(
                  child: _EmptyStateAction(
                    icon: Icons.add_rounded,
                    label: "Ajouter",
                    color: AppColors.primary,
                    onTap: () async {
                      final res = await Get.to(
                        () => const EditionPieceCouturePage(),
                      );
                      if (res is LigneMesureDto) {
                        ctl.mesure.lignesMesures.add(res);
                        ctl.update();
                      }
                    },
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _EmptyStateAction(
                    icon: Icons.mic_rounded,
                    label: "Dicter",
                    color: const Color(0xFFDC2626),
                    onTap:
                        () => GeminiMesureSheet.show(
                          context,
                          onPieceAdded: (res) {
                            ctl.mesure.lignesMesures.add(res);
                            ctl.update();
                          },
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

class _EmptyStateAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _EmptyStateAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const Gap(6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

