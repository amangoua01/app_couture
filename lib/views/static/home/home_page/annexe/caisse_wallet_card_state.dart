import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/c_card.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CaisseWalletCard extends StatelessWidget {
  final HomePageVctl ctl;
  final bool obscureBalance;
  final VoidCallback onToggleObscure;
  const CaisseWalletCard({
    super.key,
    required this.ctl,
    required this.obscureBalance,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return CCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.wallet_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.secondary,
                        size: 14,
                      ),
                      const Gap(4),
                      Text(
                        ctl.data.abonnements.isNotEmpty
                            ? ctl.data.abonnements.first.description.value
                            : "Découverte",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(8),
            const Text(
              "SOLDE DISPONIBLE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const Gap(6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: obscureBalance
                      ? const AutoSizeText(
                          "•••••• Fcfa",
                          minFontSize: 18,
                          maxFontSize: 26,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        )
                      : TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: ctl.data.caisse),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return AutoSizeText(
                              value.toAmount(unit: "Fcfa"),
                              minFontSize: 18,
                              maxFontSize: 26,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            );
                          },
                        ),
                ),
                const Gap(12),
                GestureDetector(
                  onTap: onToggleObscure,
                  child: Icon(
                    obscureBalance
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 16,
                  ),
                ),
              ],
            ),
            const Gap(5),
            obscureBalance
                ? AutoSizeText(
                    "Dépenses : •••••• Fcfa",
                    minFontSize: 11,
                    maxFontSize: 13,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                      letterSpacing: -0.5,
                    ),
                  )
                : TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: ctl.data.depenses),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return AutoSizeText(
                        "Dépenses : ${value.toAmount(unit: "Fcfa")}",
                        minFontSize: 11,
                        maxFontSize: 13,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary.withValues(alpha: 0.8),
                          letterSpacing: -0.5,
                        ),
                      );
                    },
                  ),
            if (ctl.user.isAdmin) ...[
              const Gap(5),
              Row(
                children: [
                  Expanded(
                    child: CButton(
                      height: 35,
                      icon: const Icon(Icons.add_rounded,
                          size: 16, color: AppColors.primary),
                      color: AppColors.secondary,
                      textColor: AppColors.primary,
                      title: "Déposer",
                      onPressed: ctl.goToDeposit,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: CButton(
                      height: 35,
                      icon: const Icon(Icons.remove_rounded,
                          size: 16, color: Colors.white),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      border: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3)),
                      title: "Dépense",
                      onPressed: ctl.goToDepense,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
