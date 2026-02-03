import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/controllers/home/detail_boutique_item_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EntreesStockListSubPage extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const EntreesStockListSubPage(this.ctl, {super.key});

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
                    controller: ctl.entreStockFilter.dateDebut,
                    withTime: true,
                    onClear: () {
                      ctl.entreStockFilter.dateDebut.clear();
                      ctl.update();
                    },
                    onChange: (e) {
                      ctl.entreStockFilter.dateDebut.dateTime = e;
                      ctl.update();
                    },
                  ),
                  CDateFormField(
                    labelText: "Date fin",
                    controller: ctl.entreStockFilter.dateFin,
                    withTime: true,
                    onClear: () {
                      ctl.entreStockFilter.dateFin.clear();
                      ctl.update();
                    },
                    onChange: (e) {
                      ctl.entreStockFilter.dateFin.dateTime = e;
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

          if (ctl.details == null || ctl.filteredMouvements.isEmpty) {
            return const Center(
              child: Text(
                'Aucun mouvement disponible',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: ctl.filteredMouvements.length,
            itemBuilder: (context, i) {
              final mouvement = ctl.filteredMouvements[i];
              final entreStock = mouvement.entreStock;
              final isEntree = entreStock?.type?.toLowerCase() == 'entree';

              return ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset(
                    'assets/images/svg/box.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.yellow,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                title: Text(
                  isEntree ? 'Entrée de stock' : 'Sortie de stock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isEntree ? Colors.green : Colors.red,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          isEntree
                              ? "assets/images/svg/entrant.png"
                              : "assets/images/svg/sortant.png",
                          height: 15,
                          color: isEntree ? Colors.green : Colors.red,
                        ),
                        const Gap(5),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${isEntree ? '+' : '-'}${mouvement.quantite ?? 0} ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isEntree ? Colors.green : Colors.red,
                                  ),
                                ),
                                const TextSpan(text: ' • '),
                                TextSpan(
                                  text:
                                      entreStock?.date?.toFrenchDateTime ?? '-',
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (entreStock?.statut != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: entreStock?.statut == 'CONFIRME'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            entreStock?.statut ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: entreStock?.statut == 'CONFIRME'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      '${entreStock?.quantite ?? 0}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
