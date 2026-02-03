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

class ReservationListSubPage extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const ReservationListSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => CBottomSheet.show(
          child: GetBuilder(
            init: ctl,
            builder: (_) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  CDateFormField(
                    labelText: 'Date début',
                    controller: ctl.filterReservation.dateDebut,
                    withTime: true,
                    onClear: () {
                      ctl.filterReservation.dateDebut.clear();
                      ctl.update();
                    },
                    onChange: (e) {
                      ctl.filterReservation.dateDebut.dateTime = e;
                      ctl.update();
                    },
                  ),
                  CDateFormField(
                    labelText: "Date fin",
                    controller: ctl.filterReservation.dateFin,
                    withTime: true,
                    onClear: () {
                      ctl.filterReservation.dateFin.clear();
                      ctl.update();
                    },
                    onChange: (e) {
                      ctl.filterReservation.dateFin.dateTime = e;
                      ctl.update();
                    },
                  ),
                  CDropDownFormField<String>(
                    labelText: 'Statut',
                    items: (e, f) => ['en_attente', 'confirmee', 'annulee'],
                    selectedItem: ctl.filterReservation.status,
                    itemAsString: (e) {
                      switch (e) {
                        case 'en_attente':
                          return 'En attente';
                        case 'confirmee':
                          return 'Confirmée';
                        case 'annulee':
                          return 'Annulée';
                        default:
                          return e;
                      }
                    },
                    onChanged: (e) {
                      ctl.filterReservation.status = e;
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
            },
          ),
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

          if (ctl.details == null || ctl.filteredReservations.isEmpty) {
            return const Center(
              child: Text(
                'Aucune réservation disponible',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: ctl.filteredReservations.length,
            itemBuilder: (context, i) {
              final item = ctl.filteredReservations[i];
              final reservation = item.reservation;
              final client = reservation?.client;

              // Calcul du pourcentage d'avance
              final avance = double.tryParse(reservation?.avance ?? '0') ?? 0;
              final montant = double.tryParse(reservation?.montant ?? '1') ?? 1;
              final evolution = montant > 0 ? avance / montant : 0.0;

              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: SvgPicture.asset(
                          'assets/images/svg/calendar.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.yellow,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      title: Text(
                        client?.fullName ?? 'Client inconnu',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.quantite ?? 0} unité(s)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Créée le ${reservation?.createdAt?.toFrenchDateTime ?? '-'}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          if (reservation?.dateRetrait != null)
                            Text(
                              'Retrait: ${reservation!.dateRetrait!.toFrenchDateTime}',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.primary),
                            ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: reservation?.status == 'en_attente'
                              ? Colors.orange
                              : Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          reservation?.status == 'en_attente'
                              ? 'En attente'
                              : 'Confirmée',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Avance : ${(evolution * 100).toStringAsFixed(0)}%',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                    const Gap(5),
                    LinearProgressIndicator(
                      minHeight: 8,
                      value: evolution,
                      color: AppColors.yellow,
                      backgroundColor: AppColors.green.withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Avancé: ${reservation?.avance?.toDouble().toAmount(unit: 'F') ?? '0 F'}',
                          ),
                        ),
                        Text(
                          'Total: ${reservation?.montant?.toDouble().toAmount(unit: 'F') ?? '0 F'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (reservation?.reste != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Reste à payer: ${reservation!.reste!.toDouble().toAmount(unit: 'F')}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
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
}
