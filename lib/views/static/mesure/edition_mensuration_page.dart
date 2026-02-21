import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mesure/edition_mensuration_page_vctl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionMensurationPage extends StatelessWidget {
  final LigneMesureDto ligne;
  const EditionMensurationPage(this.ligne, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionMensurationPageVctl(ligne),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.grey[50], // Fond de page légèrement gris
          appBar: AppBar(
            title: const Text("Mesures"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            centerTitle: true,
          ),
          body: Form(
            key: ctl.formKey,
            child: Column(
              children: [
                // ── En-tête informatif ──────────────────────────────────────
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.straighten_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ligne.typeMesureDto?.libelle ?? "Vêtement",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              "Saisissez les mensurations nécessaires. Désactivez celles qui ne sont pas utiles.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Liste des mensurations ──────────────────────────────────
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    itemCount: ctl.mensurations.length,
                    separatorBuilder: (_, __) => const Gap(12),
                    itemBuilder: (context, i) {
                      final e = ctl.mensurations[i];
                      final isActive = e.isActive;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isActive
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            if (isActive)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // En-tête de la carte (Titre + Switch)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.categorieMesure.libelle ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isActive
                                            ? Colors.black87
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                  CupertinoSwitch(
                                    value: isActive,
                                    activeTrackColor: AppColors.primary,
                                    onChanged: (val) {
                                      e.isActive = val;
                                      ctl.update();
                                    },
                                  ),
                                ],
                              ),

                              // Saisie (si actif)
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 250),
                                crossFadeState: isActive
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                firstChild:
                                    const SizedBox(width: double.infinity),
                                secondChild: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: CTextFormField(
                                    externalLabel: 'Valeur',
                                    require: true,
                                    initialValue: (e.valeur) > 0
                                        ? e.valeur.toString()
                                        : '',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (value) {
                                      e.valeur = value.toDouble().value;
                                    },
                                    suffix: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        "cm",
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    margin: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SafeArea(
              child: CButton(
                title: "Valider les mesures",
                onPressed: ctl.submit,
              ),
            ),
          ),
        );
      },
    );
  }
}
