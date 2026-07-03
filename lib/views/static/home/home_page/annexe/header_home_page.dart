import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/static/home/home_page/widgets/build_default_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderHomePage extends StatelessWidget {
  final HomePageVctl ctl;
  const HeaderHomePage({super.key, required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.secondary,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: ctl.user.photoProfil != null
                ? Image.network(
                    ctl.user.photoProfil!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        BuildDefaultAvatar(user: ctl.user),
                  )
                : BuildDefaultAvatar(user: ctl.user),
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bonjour, ${ctl.user.fullName.isEmpty ? 'Utilisateur' : ctl.user.fullName.split(' ').first}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -0.3,
                ),
              ),
              const Gap(3),
              Row(
                children: [
                  const Icon(
                    Icons.storefront_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const Gap(5),
                  Expanded(
                    child: Text(
                      "${ctl.getEntite().value.libelle.value} • ${ctl.getEntite().value.type == EntiteEntrepriseType.succursale ? 'Atelier' : 'Boutique'}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
