import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/periode_vente_enum.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/pill_tabs.dart';
import 'package:ateliya/tools/widgets/swipe_tabs.dart';
import 'package:ateliya/tools/widgets/vente_tile.dart';
import 'package:ateliya/tools/widgets/wrapper_listview_from_view_controller.dart';
import 'package:ateliya/views/controllers/ventes/vente_boutique_list_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text(
              "Ventes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            elevation: 0,
          ),
          body: Column(
            children: [
              const Gap(10),
              PillTabs(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 4),
                index: PeriodeVenteEnum.values.indexOf(ctl.periode),
                onChanged: (i) => ctl.changePeriode(PeriodeVenteEnum.values[i]),
                tabs: const [
                  PillTab("Tous"),
                  PillTab("Aujourd'hui"),
                  PillTab("7 jours"),
                ],
              ),
              // Sales Summary Premium Card
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3A30),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "TOTAL DES VENTES",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          "${ctl.data.items.length} vente(s) enregistrée(s)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      ctl.totalMontant.toString().toAmount(unit: "F"),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(5),
              // Animated Sales List
              Expanded(
                child: SwipeTabs<PeriodeVenteEnum>(
                  values: PeriodeVenteEnum.values,
                  selection: ctl.periode,
                  onChanged: ctl.changePeriode,
                  child: WrapperListviewFromViewController(
                    ctl: ctl,
                    itemBuilder: (_, i) {
                      final item = ctl.data.items[i];
                      return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 6,
                            ),
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
                              onDelete: ternaryFn(
                                condition: ctl.user.isAdmin,
                                ifTrue: (e) => ctl.deletePaiement(e.id.value),
                                ifFalse: null,
                              ),
                            ),
                          )
                          .animate()
                          .fade(duration: 250.ms)
                          .slideX(
                            begin: 0.05,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
