import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/constants/type_user_enum.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/home/home_page/scan_qr_code_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class VenteButton extends StatelessWidget {
  final HomePageVctl ctl;
  const VenteButton({super.key, required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ctl.getEntite().value.isNotEmpty,
      child: Visibility(
        visible: ctl.user.type?.code != TypeUserEnum.ac.code,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PlaceholderWidget(
              condition:
                  ctl.getEntite().value.type == EntiteEntrepriseType.boutique,
              placeholder: ScrollingFabAnimated(
                width: 172,
                // Le package applique un padding horizontal fixe de 15px de
                // chaque côté de l'icône (30px), non paramétrable : avec
                // l'icône à 22px (30 + 22 = 52px), une hauteur < 52px fait
                // déborder le RenderFlex interne lors du repli. On utilise
                // 56px (taille standard FAB / SpeedDial).
                height: 56,
                color: AppColors.secondary,
                // Le package ne centre pas lui-même le texte dans l'espace
                // restant une fois l'icône posée — sans ce Center, il
                // s'accroche à gauche et paraît décalé.
                text: const Center(
                  child: Text(
                    "Créer une mesure",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                icon: Icon(AppIconsBold.ruler, color: Colors.white, size: 22),
                onPress: ctl.goToMesure,
                scrollController: ctl.scrollCtl,
              ),
              child: ScrollingFabAnimated(
                width: 160,
                height: 56,
                color: AppColors.secondary,
                text: const Center(
                  child: Text(
                    "Faire une vente",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Caisse enregistreuse : plus parlant pour "faire une
                // vente" que l'icône boutique utilisée jusque-là.
                icon: const Icon(
                  AppIconsBold.cashRegister,
                  color: Colors.white,
                  size: 21,
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
              icon: AppIconsBold.plus,
              activeIcon: AppIconsBold.x,
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
                  child: Icon(AppIconsBold.userPlus, color: AppColors.primary, size: 22),
                  onTap: ctl.goToClient,
                ),
                SpeedDialChild(
                  visible:
                      (ctl.getEntite().value.type ==
                              EntiteEntrepriseType.boutique &&
                          ctl.user.isAdmin),
                  label: "Transfert de stock",
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  onTap: ctl.goToTransfert,
                  child: Icon(AppIconsBold.arrowsLeftRight, color: AppColors.primary, size: 22),
                ),
                SpeedDialChild(
                  visible: ctl.user.isAdmin,
                  label: "Créer une dépense",
                  child: Icon(AppIconsBold.receipt, color: Colors.white, size: 22),
                  backgroundColor: AppColors.primary,
                  onTap: ctl.goToDepense,
                ),
                SpeedDialChild(
                  backgroundColor: AppColors.primary,
                  label: "Scanner un reçu",
                  child: Icon(AppIconsBold.qrCode, color: Colors.white, size: 22),
                  onTap: () => Get.to(() => const ScanQrCodePage()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
