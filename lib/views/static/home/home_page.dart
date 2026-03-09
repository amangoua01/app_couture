import 'package:ateliya/data/models/abonnement.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/command_tile.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/notif_badge_icon.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/vente_tile.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/caisse/edition_mouvement_page.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:ateliya/views/static/commandes/commande_list_page.dart';
import 'package:ateliya/views/static/depense/edition_depense_page.dart';
import 'package:ateliya/views/static/home/sub_pages/select_entreprise_bottom_page.dart';
import 'package:ateliya/views/static/home/widgets/roadmap_onboarding_widget.dart';
import 'package:ateliya/views/static/mesure/edition_mesure_page.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
import 'package:ateliya/views/static/transfert_stock/edition_transfert_stock_page.dart';
import 'package:ateliya/views/static/ventes/edition_vente_multiple_page.dart';
import 'package:ateliya/views/static/ventes/vente_boutique_list_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomePageVctl(),
        builder: (ctl) {
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 40,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    "assets/images/logo_ateliya.png",
                    fit: BoxFit.contain,
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () => CBottomSheet.show(
                  child: const SelectEntrepriseBottomPage(),
                ).then((e) {
                  if (e != null) {
                    ctl.loadData();
                  }
                  ctl.update();
                }),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => const PrintListPage()),
                        child: const CircleAvatar(
                          radius: 15,
                          child: Icon(Icons.print, size: 15),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          ternaryFn(
                            condition: ctl.getEntite().value.isEmpty,
                            ifTrue: "Sélectionner une entreprise",
                            ifFalse: ctl.getEntite().value.libelle.value,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                NotifBadgeIcon(
                  count: ctl.nbUnreadNotifs,
                  onRefresh: () => ctl.loadUnreadCount(),
                ),
              ],
            ),
            floatingActionButton: Visibility(
              visible: ctl.getEntite().value.isNotEmpty,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PlaceholderWidget(
                    condition: ctl.getEntite().value.type ==
                        EntiteEntrepriseType.boutique,
                    placeholder: ScrollingFabAnimated(
                      width: 190,
                      color: AppColors.yellow,
                      text: const Text(
                        "Créer une mesure",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        "assets/images/svg/mesure.svg",
                        width: 25,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPress: () async {
                        final res =
                            await Get.to(() => const EditionMesurePage());
                        if (res != null) {
                          ctl.loadData();
                        }
                      },
                      scrollController: ctl.scrollCtl,
                    ),
                    child: ScrollingFabAnimated(
                      width: 190,
                      // radius: 20,
                      color: AppColors.yellow,
                      text: const Text(
                        "Faire une vente",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        "assets/images/svg/atelier.svg",
                        width: 25,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPress: () async {
                        final res = await Get.to(
                          () => const EditionVenteMultiplePage(),
                        );
                        if (res != null) {
                          ctl.loadData();
                        }
                      },
                      scrollController: ctl.scrollCtl,
                    ),
                  ),
                  const Gap(10),
                  SpeedDial(
                    heroTag: 'option',
                    visible: ctl.getEntite().value.isNotEmpty,
                    icon: Icons.more_vert_sharp,
                    children: [
                      SpeedDialChild(
                        label: "Créer un client",
                        child: SvgPicture.asset(
                          "assets/images/svg/client.svg",
                          width: 30,
                          colorFilter: const ColorFilter.mode(
                            AppColors.green,
                            BlendMode.srcIn,
                          ),
                        ),
                        onTap: () => Get.to(() => const EditionClientPage()),
                      ),
                      SpeedDialChild(
                        visible: (ctl.getEntite().value.type ==
                                EntiteEntrepriseType.boutique &&
                            ctl.user.isAdmin),
                        label: "Transfert de stock",
                        onTap: () async {
                          final res = await Get.to(
                            () => const EditionTransfertStockPage(),
                          );
                          if (res != null) {
                            ctl.loadData();
                          }
                        },
                        child: SvgPicture.asset(
                          "assets/images/svg/transfer_stock.svg",
                          width: 30,
                          colorFilter: const ColorFilter.mode(
                            AppColors.green,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SpeedDialChild(
                        label: "Créer une dépense",
                        visible: ctl.user.isAdmin,
                        child: const Icon(Icons.money_off, color: Colors.white),
                        backgroundColor: Colors.red,
                        onTap: () async {
                          final res =
                              await Get.to(() => const EditionDepensePage());
                          if (res != null) {
                            ctl.loadData();
                          }
                        },
                      ),
                      SpeedDialChild(
                        visible: ctl.user.isAdmin,
                        label: "Approvisionner caisse",
                        child: const Icon(Icons.wallet, color: Colors.white),
                        backgroundColor: AppColors.primary,
                        onTap: () async {
                          final res = await Get.to(
                              () => const ApprovisionnerCaissePage());
                          if (res != null) {
                            ctl.loadData();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: PlaceholderWidget(
              condition: ctl.getEntite().value.isNotEmpty,
              placeholder: ternaryFn(
                condition: ctl.user.isAdmin,
                ifTrue: RoadmapOnboardingWidget(ctl),
                ifFalse: Center(
                  child: Text(
                    "Aucune boutique ou succursale sélectionnée.\nVeuillez contacter votre administrateur.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              child: RefreshIndicator(
                onRefresh: ctl.loadData,
                child: ListView(
                  controller: ctl.scrollCtl,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 100,
                  ),
                  children: [
                    Visibility(
                      visible: ctl.user.isAdmin,
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // ── Bandeau abonnement ─────────────────────
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withValues(alpha: 0.75),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.verified_rounded,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const Gap(6),
                                            Text(
                                              ctl.data.abonnements
                                                      .firstWhere(
                                                        (e) =>
                                                            e.numero ==
                                                            ctl.data.settings
                                                                ?.numeroAbonnement,
                                                        orElse: () => Abonnement(
                                                            code: "Découverte",
                                                            description: ""),
                                                      )
                                                      .code ??
                                                  "Découverte",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: Get.width * .60,
                                              ),
                                              child: AutoSizeText(
                                                ctl
                                                    .getEntite()
                                                    .value
                                                    .libelle
                                                    .value,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 13,
                                                maxFontSize: 25,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  // fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              ternaryFn(
                                                condition: ctl
                                                        .getEntite()
                                                        .value
                                                        .type ==
                                                    EntiteEntrepriseType
                                                        .succursale,
                                                ifTrue: "Atelier",
                                                ifFalse: "Boutique",
                                              ),
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(alpha: 0.75),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(18),
                                  // ── Stats en chips ──────────────────
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _StatChip(
                                        icon: Icons.sms_outlined,
                                        label:
                                            "${ctl.data.settings?.nombreSms ?? 0} SMS",
                                      ),
                                      _StatChip(
                                        icon: Icons.people_outline,
                                        label:
                                            "${ctl.data.settings?.nombreUser ?? 0} utilisateur(s)",
                                      ),
                                      _StatChip(
                                        icon: Icons.store_outlined,
                                        label:
                                            "${ctl.data.settings?.nombreSuccursale ?? 0} atelier(s)",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),

                            // ── Stats commandes ─────────────────────
                            Visibility(
                              visible: ctl.getEntite().value.type ==
                                  EntiteEntrepriseType.succursale,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _MiniStatCard(
                                      icon: Icons.pending_actions_rounded,
                                      label: "En cours",
                                      value:
                                          "${ctl.data.commandes.where((e) => e.isActive).length}",
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: _MiniStatCard(
                                      icon: Icons.check_circle_outline_rounded,
                                      label: "Terminées",
                                      value:
                                          "${ctl.data.commandes.where((e) => !e.isActive).length}",
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(30),
                    // ── Section Mon solde ──────────────────────────────
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Mon solde",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Gap(5),
                              const Text(
                                "Caisse active",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primary,
                            Color.fromRGBO(56, 152, 160, 1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const Gap(12),
                          Text(
                            "Solde caisse",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          AutoSizeText(
                            ctl.data.caisse.toAmount(unit: "F"),
                            minFontSize: 16,
                            maxFontSize: 26,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Builder(
                      builder: (context) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ternaryFn(
                                      condition: ctl.getEntite().value.type ==
                                          EntiteEntrepriseType.boutique,
                                      ifTrue:
                                          "Meilleures ventes (${ctl.data.meilleuresVentes.length})",
                                      ifFalse:
                                          "Mes mesures (${ctl.data.commandes.length})",
                                    ),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    if (ctl.getEntite().value.type ==
                                        EntiteEntrepriseType.boutique) {
                                      Get.to(
                                          () => const VenteBoutiqueListPage());
                                    } else {
                                      Get.to(() => const CommandeListPage());
                                    }
                                  },
                                  child: const Text(
                                    "Voir plus",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Gap(15),
                            ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 100),
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, i) => const Gap(10),
                              itemBuilder: (_, i) {
                                if (ctl.getEntite().value.type ==
                                    EntiteEntrepriseType.boutique) {
                                  return VenteTile(
                                    ctl.data.meilleuresVentes[i],
                                    onPrint: () async {
                                      await ctl.printVenteReceipt(
                                        ctl.data.meilleuresVentes[i],
                                        ctl.user.entreprise?.libelle ??
                                            "Boutique",
                                        footerMessage: ctl.user.settings
                                            ?.messageFactureBoutique,
                                      );
                                    },
                                  );
                                } else {
                                  return CommandTile(
                                    mesure: ctl.data.commandes[i],
                                  );
                                }
                              },
                              itemCount: ternaryFn(
                                condition: ctl.getEntite().value.type ==
                                    EntiteEntrepriseType.boutique,
                                ifTrue: ctl.data.meilleuresVentes.length,
                                ifFalse: ctl.data.commandes.length,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// ─── Widgets locaux ──────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const Gap(5),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
