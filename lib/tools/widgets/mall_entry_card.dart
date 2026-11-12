import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/tools/services/mall_service.dart';
import 'package:ateliya/views/static/mall_ya/mall_ya_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Point d'entrée visible vers la boutique en ligne (Mall Ya).
///
/// Dans les Options, il ouvre l'écran en grand : un aplat doré, impossible à
/// manquer. Sur l'accueil, la version [compact] tient sur une ligne sous le
/// solde. Dans les deux cas, voir ce bloc réveille le site en arrière-plan,
/// pour qu'il réponde vite quand on appuie.
class MallEntryCard extends StatefulWidget {
  final String? code;
  final bool compact;
  const MallEntryCard({super.key, required this.code, this.compact = false});

  @override
  State<MallEntryCard> createState() => _MallEntryCardState();
}

class _MallEntryCardState extends State<MallEntryCard> {
  @override
  void initState() {
    super.initState();
    MallService.warmUp(widget.code);
  }

  void _ouvrir() => Get.to(() => const MallYaHomePage());

  @override
  Widget build(BuildContext context) {
    return widget.compact ? _compact() : _grand();
  }

  Widget _grand() {
    return Material(
      color: AppColors.secondary,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: _ouvrir,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
          child: Row(
            children: [
              const Icon(
                AppIconsBold.storefront,
                size: 34,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mall Ya · votre boutique en ligne',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Voir, partager et configurer votre vitrine',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(11),
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  AppIconsBold.arrowRight,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _compact() {
    return InkWell(
      onTap: _ouvrir,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFDDE3DF)),
        ),
        child: Row(
          children: [
            Container(width: 3, height: 34, color: AppColors.secondary),
            const SizedBox(width: 12),
            const Icon(AppIcons.storefront, size: 24, color: AppColors.primary),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Votre boutique en ligne',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Voir, partager, configurer · Mall Ya',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(AppIcons.caretRight, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
