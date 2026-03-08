import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:ateliya/views/static/mesure/edition_mensuration_page.dart';
import 'package:ateliya/views/static/mesure/edition_piece_couture_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ListPieceSubPage extends StatelessWidget {
  final EditionMesurePageVctl ctl;
  const ListPieceSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Get.to(
            () => const EditionPieceCouturePage(),
          );
          if (res is LigneMesureDto) {
            ctl.mesure.lignesMesures.add(res);
            ctl.update();
          }
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          "Ajouter une pièce",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: WrapperListview(
        items: ctl.mesure.lignesMesures,
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        itemBuilder: (e, index) {
          final valideMensurations = e.typeMesureDto?.mensurations
                  .where((m) =>
                      m.isActive && m.valeur.isNotEmpty && m.valeur != "0")
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
                                    color: Colors.black87,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  e.typeMesureDto == null
                                      ? "Aucun modèle"
                                      : "Modèle : ${e.typeMesureDto!.libelle}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
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
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.red, size: 20),
                          ),
                        ],
                      ),

                      // Price / Calculation Section
                      if (e.getCalcul != "0") ...[
                        const Gap(16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.payments_outlined,
                                  size: 16, color: Colors.green),
                              const Gap(6),
                              Text(
                                "Montant : ${e.getCalcul}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],

                      const Gap(16),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const Gap(12),

                      // Tags Mensurations Detailed
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PlaceholderBuilder(
                              condition: valideMensurations.isNotEmpty,
                              placeholder: const Padding(
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
                              ),
                              builder: () {
                                return Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: valideMensurations.map((m) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${m.categorieMesure.libelle} : ",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[700]),
                                          ),
                                          Text(
                                            "${m.valeur} cm",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                          const Gap(12),
                          // Measure Button
                          ElevatedButton.icon(
                            onPressed: () async {
                              final res = await Get.to(
                                () => EditionMensurationPage(e),
                              );
                              if (res is List<MensurationDto>) {
                                e.typeMesureDto!.mensurations = res;
                                ctl.update();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: SvgPicture.asset(
                              "assets/images/svg/measure_meter.svg",
                              height: 18,
                              width: 18,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: const Text(
                              "Mesurer",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
