import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/constants/env.dart';
import 'package:app_couture/tools/extensions/ternary_fn.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/card_info.dart';
import 'package:app_couture/tools/widgets/command_tile.dart';
import 'package:app_couture/tools/widgets/empty_data_widget.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/tools/widgets/placeholder_builder.dart';
import 'package:app_couture/tools/widgets/placeholder_widget.dart';
import 'package:app_couture/tools/widgets/solde_card.dart';
import 'package:app_couture/views/controllers/home/home_page_vctl.dart';
import 'package:app_couture/views/static/boutiques/edition_boutique_page.dart';
import 'package:app_couture/views/static/clients/edition_client_page.dart';
import 'package:app_couture/views/static/commandes/commande_list_page.dart';
import 'package:app_couture/views/static/home/sub_pages/select_entreprise_bottom_page.dart';
import 'package:app_couture/views/static/home/sub_pages/transaction_bottom_page.dart';
import 'package:app_couture/views/static/mesure/edition_mesure_page.dart';
import 'package:app_couture/views/static/notifs/notif_list_page.dart';
import 'package:app_couture/views/static/surcursales/edition_surcusale_page.dart';
import 'package:app_couture/views/static/ventes/edition_vente_page.dart';
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
              actionsPadding: const EdgeInsets.only(right: 10),
              title: PlaceholderWidget(
                condition: ctl.user.isAdmin,
                placeholder: PlaceholderBuilder(
                  condition: ctl.user.login.value.split('@').isNotEmpty,
                  placeholder: const Text(
                    Env.appName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  builder: () {
                    return Text(
                      "Bienvenue, ${ctl.user.login.value.split('@').first}",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                child: GestureDetector(
                  onTap: () => CBottomSheet.show(
                    child: const SelectEntrepriseBottomPage(),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(radius: 10),
                        Gap(10),
                        Expanded(
                          child: Text(
                            "Sélectionner une entreprise",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => Get.to(() => const NotifListPage()),
                  icon: SvgPicture.asset(
                    "assets/images/svg/notif.svg",
                    width: 30,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: SpeedDial(
              heroTag: 'option',
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
                  label: "Créer une mesure",
                  child: SvgPicture.asset(
                    "assets/images/svg/mesure.svg",
                    width: 30,
                    colorFilter: const ColorFilter.mode(
                      AppColors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () => Get.to(() => const EditionMesurePage()),
                ),
                SpeedDialChild(
                  label: "Faire une vente",
                  onTap: () => Get.to(() => const EditionVentePage()),
                  child: SvgPicture.asset(
                    "assets/images/svg/atelier.svg",
                    width: 30,
                    colorFilter: const ColorFilter.mode(
                      AppColors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            body: PlaceholderWidget(
              condition: ctl.entite.isNotEmpty,
              placeholder: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyDataWidget(
                    message: ternaryFn(
                      condition: ctl.user.isAdmin,
                      ifTrue:
                          "Aucune boutique ou surcussale ?\nCréez-en une pour continuer.",
                      ifFalse:
                          "Vous n'êtes rattaché à aucune entreprise.\nVeuillez contacter votre administrateur.",
                    ),
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(top: 20, bottom: 40),
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
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CardInfo(
                                    icon: "assets/images/svg/ticket.svg",
                                    value: "Découverte",
                                  ),
                                  CardInfo(
                                    icon: "assets/images/svg/sms.svg",
                                    value: "2 000 SMS",
                                  ),
                                  CardInfo(
                                    icon: "assets/images/svg/users.svg",
                                    value: "15 utilisateur(s)",
                                  ),
                                  CardInfo(
                                    icon: "assets/images/svg/store.svg",
                                    value: "5 atelier(s)",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "ATELIER ANGRÉ",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  CardInfo(
                                    color: AppColors.primary,
                                    icon: "assets/images/svg/waiting.svg",
                                    value: "Cmd. en cours (12)",
                                    height: 15,
                                  ),
                                  CardInfo(
                                    color: AppColors.primary,
                                    icon: "assets/images/svg/check.svg",
                                    value: "Cmd. terminé (2)",
                                    height: 15,
                                  ),
                                  CardInfo(
                                    color: AppColors.primary,
                                    icon: "assets/images/svg/reservation.svg",
                                    value: "Réservation (2)",
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
                  const Text(
                    "Mon solde",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: () => CBottomSheet.show(
                      child: const TransactionBottomPage(),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.fieldBorder),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: SoldeCard(
                                icon: "assets/images/svg/entrant.png",
                                value: "10 000 FCFA",
                              ),
                            ),
                          ),
                          Gap(10),
                          Expanded(
                            child: Center(
                              child: SoldeCard(
                                icon: "assets/images/svg/sortant.png",
                                value: "10 000 FCFA",
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 12)
                        ],
                      ),
                    ),
                  ),
                  const Gap(30),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Mes commandes (10)",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => Get.to(() => const CommandeListPage()),
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
                    separatorBuilder: (_, i) => const Divider(),
                    itemBuilder: (_, i) => const CommandTile(),
                    itemCount: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
