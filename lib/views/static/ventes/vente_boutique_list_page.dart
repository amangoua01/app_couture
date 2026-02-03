import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/meilleure_vente_tile.dart';
import 'package:ateliya/tools/widgets/wrapper_listview_from_view_controller.dart';
import 'package:ateliya/views/controllers/ventes/vente_list_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class VenteBoutiqueListPage extends StatelessWidget {
  const VenteBoutiqueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: VenteListVctl(),
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
                    itemCount: ctl.periodes.length,
                    separatorBuilder: (_, __) => const Gap(10),
                    itemBuilder: (_, i) {
                      return GetBuilder<VenteListVctl>(builder: (_) {
                        final isSelected = ctl.periode == ctl.periodes[i];
                        return GestureDetector(
                          onTap: () => ctl.changePeriode(ctl.periodes[i]),
                          child: Chip(
                            label: Text(ctl.periodes[i]),
                            backgroundColor: isSelected
                                ? AppColors.primary
                                : Colors.grey[200],
                            labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                    color: Colors.transparent)),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: WrapperListviewFromViewController(
                    ctl: ctl,
                    itemBuilder: (_, i) {
                      final item = ctl.data.items[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: MeilleureVenteTile.fromPaiementBoutique(item),
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
