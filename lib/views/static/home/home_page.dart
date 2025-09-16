import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/card_info.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/tools/widgets/solde_card.dart';
import 'package:app_couture/views/static/home/sub_pages/transaction_bottom_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/images/notif.png",
              width: 22,
            ),
          ),
          CircleAvatar(
            // radius: 15,
            backgroundColor: AppColors.primary,
            child: IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: Image.asset(
                "assets/images/user.png",
                width: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 25),
            color: AppColors.primary,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bienvenue, Atelier angré",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  color: AppColors.yellow,
                  size: 35,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        backgroundColor: AppColors.primary,
        children: [
          SpeedDialChild(
            label: "Créer une boutique",
            child: SvgPicture.asset(
              "assets/images/svg/store.svg",
              width: 30,
              colorFilter: const ColorFilter.mode(
                AppColors.green,
                BlendMode.srcIn,
              ),
            ),
          ),
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
          ),
          SpeedDialChild(
            label: "Ajouter un atélier",
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
      body: ListView(
        padding: const EdgeInsets.only(right: 20, left: 20),
        children: [
          Card(
            elevation: 12,
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
          const Gap(40),
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
                onPressed: () {},
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
          const Gap(20),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder(
              borderRadius: BorderRadius.circular(10),
              horizontalInside: const BorderSide(
                width: .4,
                color: AppColors.fieldBorder,
              ),
              top: const BorderSide(
                width: .4,
                color: AppColors.fieldBorder,
              ),
              bottom: const BorderSide(
                width: .4,
                color: AppColors.fieldBorder,
              ),
              left: const BorderSide(
                width: .4,
                color: AppColors.fieldBorder,
              ),
              right: const BorderSide(
                width: .4,
                color: AppColors.fieldBorder,
              ),
            ),
            children: List.generate(
              10,
              (i) => const TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "22/05/2025",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Konaté Hamed",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  TableCell(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Chemise - pentalon",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        "Lundi 1 sep. 08H00",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
