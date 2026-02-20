import 'package:ateliya/data/models/abonnement.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/card_info.dart';
import 'package:ateliya/tools/widgets/command_tile.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/notif_badge_icon.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/vente_tile.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/boutiques/edition_boutique_page.dart';
import 'package:ateliya/views/static/caisse/edition_mouvement_page.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:ateliya/views/static/commandes/commande_list_page.dart';
import 'package:ateliya/views/static/depense/edition_depense_page.dart';
import 'package:ateliya/views/static/home/sub_pages/select_entreprise_bottom_page.dart';
import 'package:ateliya/views/static/mesure/edition_mesure_page.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
import 'package:ateliya/views/static/surcursales/edition_surcusale_page.dart';
import 'package:ateliya/views/static/ventes/edition_vente_multiple_page.dart';
import 'package:ateliya/views/static/ventes/vente_boutique_list_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
            floatingActionButton: SpeedDial(
              heroTag: 'option',
              visible: ctl.getEntite().value.isNotEmpty,
              icon: Icons.add,
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
                  visible: ctl.getEntite().value.type ==
                      EntiteEntrepriseType.succursale,
                  label: "Créer une mesure",
                  child: SvgPicture.asset(
                    "assets/images/svg/mesure.svg",
                    width: 30,
                    colorFilter: const ColorFilter.mode(
                      AppColors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () async {
                    final res = await Get.to(() => const EditionMesurePage());
                    if (res != null) {
                      ctl.loadData();
                    }
                  },
                ),
                SpeedDialChild(
                  visible: (ctl.getEntite().value.type ==
                      EntiteEntrepriseType.boutique),
                  label: "Faire une vente",
                  onTap: () async {
                    final res =
                        await Get.to(() => const EditionVenteMultiplePage());
                    if (res != null) {
                      ctl.loadData();
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/images/svg/atelier.svg",
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
                    final res = await Get.to(() => const EditionDepensePage());
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
                    final res =
                        await Get.to(() => const ApprovisionnerCaissePage());
                    if (res != null) {
                      ctl.loadData();
                    }
                  },
                ),
              ],
            ),
            body: PlaceholderWidget(
              condition: ctl.getEntite().value.isNotEmpty,
              placeholder: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyDataWidget(
                    message: "Aucune boutique ou surcussale ?"
                        "\nCréez-en une pour continuer.",
                    onRefresh: ternaryFn(
                      condition: ctl.user.isAdmin,
                      ifTrue: () => Get.to(() => const EditionBoutiquePage()),
                      ifFalse: null,
                    ),
                    buttonTitle: "Créer une boutique",
                  ),
                  Visibility(
                    visible: ctl.user.isAdmin,
                    child: TextButton(
                      onPressed: () =>
                          Get.to(() => const EditionSurcusalePage()),
                      child: const Text("Créer une succursale"),
                    ),
                  ),
                ],
              ),
              child: RefreshIndicator(
                onRefresh: ctl.loadData,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Visibility(
                      visible: ctl.user.isAdmin,
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(top: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: Get.width,
                          height: 150,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.greenLight2,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CardInfo(
                                        icon: "assets/images/svg/ticket.svg",
                                        value: ctl.data.abonnements
                                                .firstWhere(
                                                    (e) =>
                                                        e.numero ==
                                                        ctl.data.settings
                                                            ?.numeroAbonnement,
                                                    orElse: () => Abonnement(
                                                        code: "Inconnu",
                                                        description: "Inconnu"))
                                                .code ??
                                            "Découverte",
                                      ),
                                      CardInfo(
                                        icon: "assets/images/svg/sms.svg",
                                        value:
                                            "${ctl.data.settings?.nombreSms ?? 0} SMS",
                                      ),
                                      CardInfo(
                                        icon: "assets/images/svg/users.svg",
                                        value:
                                            "${ctl.data.settings?.nombreUser ?? 0} utilisateur(s)",
                                      ),
                                      CardInfo(
                                        icon: "assets/images/svg/store.svg",
                                        value:
                                            "${ctl.data.settings?.nombreSuccursale ?? 0} atelier(s)",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${ternaryFn(
                                          condition: ctl
                                                  .getEntite()
                                                  .value
                                                  .type ==
                                              EntiteEntrepriseType.succursale,
                                          ifTrue: "Atélier",
                                          ifFalse: "Boutique",
                                        )} ${ctl.getEntite().value.libelle.value}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      CardInfo(
                                        color: AppColors.primary,
                                        icon: "assets/images/svg/waiting.svg",
                                        value:
                                            "Cmd. en cours (${ctl.data.commandes.where((e) => e.isActive).length})",
                                        height: 15,
                                      ),
                                      const CardInfo(
                                        color: AppColors.primary,
                                        icon: "assets/images/svg/check.svg",
                                        value: "Cmd. terminé (0)",
                                        height: 15,
                                      ),
                                      const CardInfo(
                                        color: AppColors.primary,
                                        icon:
                                            "assets/images/svg/reservation.svg",
                                        value: "Réservation (0)",
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),
                    const Text(
                      "Mon solde",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    GestureDetector(
                      // onTap: () => CBottomSheet.show(
                      //   child: const TransactionBottomPage(),
                      // ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.fieldBorder),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              "assets/images/svg/entrant.png",
                              height: 20,
                            ),
                          ),
                          title: AutoSizeText(
                            ctl.data.caisse.toAmount(unit: "F"),
                            minFontSize: 15,
                            maxFontSize: 20,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // trailing: const Icon(
                          //   Icons.arrow_forward_ios,
                          //   size: 12,
                          // ),
                        ),
                        // child: SoldeCard(
                        //   icon: "assets/images/svg/entrant.png",
                        //   value: ctl.data.caisse.toAmount(unit: "F"),
                        // ),
                      ),
                    ),
                    const Gap(30),
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
