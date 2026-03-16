import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/periode_vente_enum.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/vente_tile.dart';
import 'package:ateliya/tools/widgets/wrapper_listview_from_view_controller.dart';
import 'package:ateliya/views/controllers/ventes/vente_boutique_list_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class VenteBoutiqueListPage extends StatelessWidget {
  const VenteBoutiqueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: VenteBoutiqueListPageVctl(),
        builder: (ctl) {
          return Scaffold(
            appBar: AppBar(title: const Text("Ventes")),
            body: Column(
              children: [
                const Gap(15),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: PeriodeVenteEnum.values.length,
                    separatorBuilder: (_, __) => const Gap(10),
                    itemBuilder: (_, i) {
                      final isSelected =
                          ctl.periode == PeriodeVenteEnum.values[i];
                      return GestureDetector(
                        onTap: () => ctl.changePeriode(
                          PeriodeVenteEnum.values[i],
                        ),
                        child: Chip(
                          label: Text(PeriodeVenteEnum.values[i].label),
                          backgroundColor: ternaryFn(
                            condition: isSelected,
                            ifTrue: AppColors.primary,
                            ifFalse: Colors.grey[200],
                          ),
                          labelStyle: TextStyle(
                            color: ternaryFn(
                              condition: isSelected,
                              ifTrue: Colors.white,
                              ifFalse: Colors.black,
                            ),
                            fontWeight: ternaryFn(
                              condition: isSelected,
                              ifTrue: FontWeight.bold,
                              ifFalse: FontWeight.normal,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total des ventes",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(5),
                            Text(
                              "${ctl.data.items.length} vente(s)",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ctl.totalMontant.toString().toAmount(unit: "F"),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(5),
                Expanded(
                  child: WrapperListviewFromViewController(
                    ctl: ctl,
                    itemBuilder: (_, i) {
                      final item = ctl.data.items[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: VenteTile(
                          item,
                          onPrint: () async {
                            await ctl.printVenteReceipt(
                              item,
                              ctl.user.entreprise?.libelle ?? "Boutique",
                              footerMessage:
                                  ctl.user.settings?.messageFactureBoutique,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
