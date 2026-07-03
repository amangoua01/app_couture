import 'package:ateliya/data/models/abonnement.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ticket_widget/ticket_widget.dart';

class AbonnementTile extends StatelessWidget {
  final Abonnement item;
  const AbonnementTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isActive = item.etat;
    final Color tileBg = isActive ? AppColors.primary : Colors.white;
    
    // Thème de couleur dynamique (Coupon vert pour Actif, blanc pour Inactif)
    final Color outerBorderColor = isActive 
        ? Colors.transparent 
        : const Color(0xFFE5ECE9);
        
    final Color textColor = isActive ? Colors.white : const Color(0xFF0F231F);
    final Color subtitleColor = isActive ? Colors.white.withValues(alpha: 0.65) : const Color(0xFF6E8E87);
    final Color borderDividerColor = isActive ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFE5ECE9);
    
    final Color advantagesBg = isActive
        ? Colors.white.withValues(alpha: 0.16)
        : AppColors.primary.withValues(alpha: 0.06);
    final Color advantagesText = isActive
        ? Colors.white
        : AppColors.primary;
        
    final Color priceBg = isActive
        ? AppColors.yellow
        : AppColors.primary.withValues(alpha: 0.06);
    final Color priceText = isActive
        ? AppColors.primary
        : AppColors.primary;
        
    final Color statusColor = isActive ? AppColors.yellow : Colors.grey.shade600;
    final Color statusBg = isActive 
        ? Colors.white.withValues(alpha: 0.16) 
        : Colors.grey.withValues(alpha: 0.08);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: outerBorderColor,
          width: isActive ? 0 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive 
                ? AppColors.primary.withValues(alpha: 0.22)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: isActive ? 16 : 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TicketWidget(
        color: tileBg,
        width: double.maxFinite,
        height: 185,
        isCornerRounded: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec bouton avantages et statut
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton voir les avantages (Style moderne à plat)
                  GestureDetector(
                    onTap: () => _showAvantages(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: advantagesBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/svg/list.svg',
                            width: 13,
                            colorFilter: ColorFilter.mode(
                              advantagesText,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            'Avantages',
                            style: TextStyle(
                              color: advantagesText,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Badge de statut (Pill Premium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? Icons.check_circle_rounded : Icons.info_rounded,
                          color: statusColor,
                          size: 14,
                        ),
                        const Gap(4),
                        Text(
                          isActive ? "Actif" : "Inactif",
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Gap(4),

            // Contenu principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type et montant
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Formule',
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(1),
                                Text(
                                  item.type.value.capitalize(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                    fontSize: 17.5,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: priceBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.montant.toAmount(unit: "F"),
                              style: TextStyle(
                                color: priceText,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(14),

                    // Dates de validité
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Début',
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(3),
                              Text(
                                (item.dateDebut?.toString() ?? "").toFrenchDateTime,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          color: borderDividerColor,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Fin',
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(3),
                              Text(
                                (item.dateFin?.toString() ?? "").toFrenchDateTime,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Gap(10),
          ],
        ),
      ),
    );
  }

  void _showAvantages(BuildContext context) {
    CBottomSheet.show(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: AppColors.yellow,
                  size: 28,
                ),
                Gap(10),
                Text(
                  'Avantages inclus',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const Gap(15),
            const Divider(),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: item.modules.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/svg/piece.svg',
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  title: Text(
                    item.modules[i].libelle.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F231F),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.modules[i].description.value,
                      style: TextStyle(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.modules[i].quantite.toAmount(unit: ""),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.yellow,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
