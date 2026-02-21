import 'package:ateliya/data/models/vente.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/controllers/ventes/detail_vente_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DetailVentePage extends StatelessWidget {
  final Vente vente;

  const DetailVentePage({super.key, required this.vente});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailVentePageVctl>(
      init: DetailVentePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Détail de la vente"),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card with Reference
                _buildCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Référence",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                vente.reference ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 12,
                          //     vertical: 6,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: (vente.isActive ?? true)
                          //         ? AppColors.green.withValues(alpha: 0.1)
                          //         : Colors.grey.withValues(alpha: 0.1),
                          //     borderRadius: BorderRadius.circular(20),
                          //     border: Border.all(
                          //       color: (vente.isActive ?? true)
                          //           ? AppColors.green
                          //           : Colors.grey,
                          //     ),
                          //   ),
                          //   child: Text(
                          //     (vente.type ?? "") == "vente" ? "Active" : "Inactive",
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.bold,
                          //       color: (vente.type ?? "") == "vente"
                          //           ? AppColors.green
                          //           : Colors.grey,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      if (vente.createdAt != null) ...[
                        const Gap(15),
                        const Divider(),
                        const Gap(10),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey),
                            const Gap(8),
                            Text(
                              vente.createdAt.toFrenchDateTime,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const Gap(20),

                // Client Info Card
                if (vente.client != null) ...[
                  _buildSectionTitle("Informations Client"),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vente.client!.fullName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (vente.client!.tel != null) ...[
                                    const Gap(4),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            size: 14, color: Colors.grey),
                                        const Gap(4),
                                        Text(
                                          vente.client!.tel!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                ],

                // Articles vendus
                _buildSectionTitle("Articles vendus"),
                ...(vente.paiementBoutiqueLignes).map((ligne) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ligne.modeleBoutique?.modele?.libelle ??
                                        "Article",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Gap(6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "Qté: ${ligne.quantite ?? 1}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        ligne.montant.value.toAmount(unit: "F"),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  ligne.total.toAmount(unit: "F"),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),

                const Gap(20),

                // Résumé financier
                _buildSectionTitle("Résumé"),
                _buildCard(
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        "Nombre d'articles",
                        "${vente.paiementBoutiqueLignes.length}",
                        isBold: false,
                      ),
                      const Gap(10),
                      const Divider(),
                      const Gap(10),
                      _buildSummaryRow(
                        "Quantité totale",
                        "${vente.quantite}",
                        isBold: false,
                      ),
                      const Gap(10),
                      const Divider(),
                      const Gap(10),
                      _buildSummaryRow(
                        "Montant Total",
                        vente.montant.toAmount(unit: "F"),
                        isBold: true,
                        valueColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),

                const Gap(30),

                // Action Button (Print)
                CButton(
                  title: 'Imprimer (BT)',
                  color: Colors.black87,
                  icon: const Icon(Icons.print, color: Colors.white, size: 18),
                  onPressed: () => ctl.printReceipt(
                      vente, ctl.user.entreprise?.libelle ?? "Boutique"),
                ),
                const Gap(20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
