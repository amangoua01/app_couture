import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class VenteButton extends StatelessWidget {
  final HomePageVctl ctl;
  const VenteButton({super.key, required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ctl.getEntite().value.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          PlaceholderWidget(
            condition:
                ctl.getEntite().value.type == EntiteEntrepriseType.boutique,
            placeholder: ScrollingFabAnimated(
              width: 190,
              color: AppColors.secondary,
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
              onPress: ctl.goToMesure,
              scrollController: ctl.scrollCtl,
            ),
            child: ScrollingFabAnimated(
              width: 190,
              color: AppColors.secondary,
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
              onPress: ctl.goToVente,
              scrollController: ctl.scrollCtl,
            ),
          ),
          const Gap(10),
          SpeedDial(
            heroTag: 'option',
            visible: ctl.getEntite().value.isNotEmpty,
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            activeBackgroundColor: AppColors.primary,
            activeForegroundColor: Colors.white,
            icon: Icons.menu_open_rounded,
            activeIcon: Icons.close_rounded,
            children: [
              SpeedDialChild(
                label: "Créer un client",
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 13,
                ),
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                child: SvgPicture.asset(
                  "assets/images/svg/client.svg",
                  width: 22,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: ctl.goToClient,
              ),
              SpeedDialChild(
                visible: (ctl.getEntite().value.type ==
                        EntiteEntrepriseType.boutique &&
                    ctl.user.isAdmin),
                label: "Transfert de stock",
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                onTap: ctl.goToTransfert,
                child: SvgPicture.asset(
                  "assets/images/svg/transfer_stock.svg",
                  width: 22,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SpeedDialChild(
                label: "Créer une dépense",
                visible: ctl.user.isAdmin,
                child: const Icon(Icons.money_off_rounded,
                    color: Colors.white, size: 20),
                backgroundColor: AppColors.yellow,
                onTap: ctl.goToDepense,
              ),
              SpeedDialChild(
                visible: ctl.user.isAdmin,
                label: "Approvisionner caisse",
                child: const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.white, size: 20),
                backgroundColor: AppColors.primary,
                onTap: ctl.goToDeposit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
