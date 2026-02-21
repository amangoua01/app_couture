import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/controllers/home/detail_boutique_item_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class VenteListSubPage extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const VenteListSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => CBottomSheet.show(
          child: GetBuilder(
              init: ctl,
              builder: (_) {
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      "Filtrer les ventes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
                    CDateFormField(
                      labelText: 'Date début',
                      controller: ctl.filterVente.dateDebut,
                      withTime: true,
                      onClear: () {
                        ctl.filterVente.dateDebut.clear();
                        ctl.update();
                      },
                      onChange: (e) {
                        ctl.filterVente.dateDebut.dateTime = e;
                        ctl.update();
                      },
                    ),
                    CDateFormField(
                      labelText: "Date fin",
                      withTime: true,
                      controller: ctl.filterVente.dateFin,
                      onClear: () {
                        ctl.filterVente.dateDebut.clear();
                        ctl.update();
                      },
                      onChange: (e) {
                        ctl.filterVente.dateFin.dateTime = e;
                        ctl.update();
                      },
                    ),
                    CDropDownFormField(
                      labelText: 'Client',
                      items: (e, f) => ctl.modele.clients,
                      selectedItem: ctl.filterVente.client,
                      itemAsString: (e) => e.fullName,
                      onChanged: (e) {
                        ctl.filterVente.client = e;
                        ctl.update();
                      },
                    ),
                    const Gap(20),
                    CButton(
                      title: 'Appliquer',
                      onPressed: () {
                        ctl.update();
                        Get.back();
                      },
                    ),
                  ],
                );
              }),
        ),
        child: SvgPicture.asset(
          'assets/images/svg/filter.svg',
          height: 30,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
      body: GetBuilder<DetailBoutiqueItemPageVctl>(
        init: ctl,
        builder: (_) {
          if (ctl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctl.details == null || ctl.filteredVentes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const Gap(16),
                  const Text(
                    'Aucune vente disponible',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Les ventes apparaîtront ici',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ctl.filteredVentes.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, i) {
              final vente = ctl.filteredVentes[i];
              final client = vente.paiementBoutique?.client;
              final montantUnitaire = vente.montant?.toDouble().value ?? 0.0;
              final quantite = vente.quantite ?? 0;
              final montantTotal =
                  vente.paiementBoutique?.montant?.toDouble().value ?? 0.0;

              return Container(
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
                child: Column(
                  children: [
                    // En-tête avec icône et référence
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/svg/bag.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vente.paiementBoutique?.reference ?? 'N/A',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Gap(2),
                                Text(
                                  vente.paiementBoutique?.createdAt
                                          ?.toFrenchDateTime ??
                                      '-',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              montantTotal.toAmount(unit: 'F'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Détails de la vente
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Ligne quantité et prix unitaire
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoRow(
                                  icon: Icons.inventory_2_outlined,
                                  label: 'Quantité',
                                  value:
                                      '$quantite article${quantite > 1 ? 's' : ''}',
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: _buildInfoRow(
                                  icon: Icons.attach_money,
                                  label: 'Prix unitaire',
                                  value: montantUnitaire.toAmount(unit: 'F'),
                                ),
                              ),
                            ],
                          ),

                          // Client si disponible
                          if (client != null) ...[
                            const Gap(12),
                            const Divider(height: 1),
                            const Gap(12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        client.fullName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (client.tel != null &&
                                          client.tel!.isNotEmpty) ...[
                                        const Gap(2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone_outlined,
                                              size: 14,
                                              color: Colors.grey[600],
                                            ),
                                            const Gap(4),
                                            Text(
                                              client.tel!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const Gap(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              const Gap(2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
