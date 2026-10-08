import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/home/setting_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// En-tête de la page Réglages : identité et QR code de l'utilisateur (version compacte).
class UnifiedProfileHeader extends StatelessWidget {
  final SettingPageVctl ctl;
  const UnifiedProfileHeader({required this.ctl, super.key});

  @override
  Widget build(BuildContext context) {
    final userName =
        ctl.user.fullName.isNotEmpty
            ? ctl.user.fullName
            : ctl.user.nom.value.isNotEmpty
            ? ctl.user.nom.value
            : "Utilisateur";

    final code =
        ctl.user.isAdmin
            ? (ctl.user.entreprise?.codeMarchand ?? "")
            : (ctl.user.myReferralCode ?? "");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2620), Color(0xFF133C30)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Partie Gauche : Nom, Code Marchand
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nom
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(2),
                Text(
                  ctl.user.isAdmin ? "Administrateur" : "Collaborateur",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (code.isNotEmpty) ...[
                  const Gap(12),
                  // Code Marchand / Parrainage
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withOpacity(0.15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.tag_rounded, size: 12, color: AppColors.secondary),
                              const Gap(4),
                              Text(
                                code,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(8),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: code));
                          Get.snackbar(
                            "Copié !",
                            "Code copié dans le presse-papiers.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF112C26),
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(15),
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.copy_rounded, color: AppColors.secondary, size: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (code.isNotEmpty) ...[
            const Gap(16),
            // Partie Droite : QR Code
            GestureDetector(
              onTap: () => _showZoomedQrCode(context, code, ctl),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Hero(
                  tag: 'qr_code_hero',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$code&color=0a3a30",
                      width: 60,
                      height: 60,
                      errorBuilder: (_, __, ___) => const Icon(Icons.qr_code_2_rounded, size: 60, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showZoomedQrCode(
    BuildContext context,
    String code,
    SettingPageVctl ctl,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ctl.user.isAdmin ? "Mon Code Marchand" : "Mon Code Parrainage",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Hero(
                tag: 'qr_code_hero',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
                    border: Border.all(color: AppColors.primary.withOpacity(0.08)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=$code&color=0a3a30",
                      width: 200,
                      height: 200,
                      errorBuilder: (_, __, ___) => const Icon(Icons.qr_code_2_rounded, size: 200, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                    ),
                    child: Text(
                      code,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppColors.primary),
                    ),
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: code));
                      Get.snackbar("Code copié !", "Le code a été copié dans le presse-papiers.", snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFF112C26), colorText: Colors.white, margin: const EdgeInsets.all(15), duration: const Duration(seconds: 2));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.primary.withOpacity(0.1))),
                      child: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 18),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Text(
                ctl.user.isAdmin ? "Partagez ce QR Code pour inviter des collaborateurs à rejoindre votre atelier." : "Partagez ce QR Code pour parrainer un nouvel atelier.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
