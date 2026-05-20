import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/data/models/operateur.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/abonnements/abonnement_payment_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AbonnementPaymentPage extends StatelessWidget {
  final ModuleAbonnement forfait;
  final Operateur operateur;

  const AbonnementPaymentPage({
    required this.forfait,
    required this.operateur,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AbonnementPaymentPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text("Récapitulatif & Paiement"),
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Forfait
                const Text(
                  "Forfait sélectionné",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            forfait.libelle ?? "Forfait",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            "${forfait.montant.toAmount()} FCFA",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      _buildRecapRow(Icons.timer_outlined, "Durée",
                          "${forfait.duree} Jours"),
                      const Gap(10),
                      _buildRecapRow(Icons.description_outlined, "Description",
                          forfait.description ?? "N/A"),
                    ],
                  ),
                ),

                const Gap(30),

                // Section Opérateur
                const Text(
                  "Moyen de paiement",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/images/svg/mobile.svg",
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const Gap(15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              operateur.libelle ?? "Opérateur",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Paiement Mobile",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Modifier"),
                      ),
                    ],
                  ),
                ),

                const Gap(30),

                // Saisie du numéro
                const Text(
                  "Numéro de téléphone",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(12),
                TextField(
                  controller: ctl.phoneCtl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "XXXXXXXXXX",
                    prefixIcon: const Icon(Icons.phone_android),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),

                const Gap(40),

                // Bouton de validation
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: ctl.isLoading
                        ? null
                        : () {
                            if (ctl.phoneCtl.text.length < 8) {
                              Get.snackbar(
                                "Erreur",
                                "Veuillez saisir un numéro de téléphone valide",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            // Confirmation de validation
                            Get.dialog(
                              AlertDialog(
                                title: const Text("Confirmation"),
                                content: const Text(
                                    "Voulez-vous valider le paiement de cet abonnement ?"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text("Annuler")),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      ctl.validatePayment(
                                        forfaitId: forfait.id!,
                                        operateur: operateur,
                                      );
                                    },
                                    child: const Text("Confirmer"),
                                  ),
                                ],
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: ctl.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "VALIDER LE PAIEMENT",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecapRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const Gap(10),
        Text(
          "$label:",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const Gap(10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
