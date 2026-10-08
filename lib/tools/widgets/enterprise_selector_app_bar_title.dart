import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/cache_key.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/widgets/animations/pressable.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/static/home/sub_pages/select_entreprise_bottom_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

typedef _RxEntiteEntreprise = Rx<EntiteEntreprise>;

/// Pastille "entreprise active" de l'app bar : lit l'entité directement
/// dans le registre GetX plutôt que de recevoir un titre figé passé par
/// l'écran — avant ça, chaque écran gardait son propre texte gelé au
/// moment de son dernier `update()`, et comme les onglets restent montés
/// en arrière-plan (IndexedStack), changer d'entité depuis un onglet
/// laissait les autres affichés avec un texte vide ou périmé.
class EnterpriseSelectorAppBarTitle extends StatelessWidget {
  final VoidCallback onSelectionChanged;

  const EnterpriseSelectorAppBarTitle({
    super.key,
    required this.onSelectionChanged,
  });

  _RxEntiteEntreprise get _entite {
    if (Get.isRegistered<_RxEntiteEntreprise>(tag: CacheKey.entite.name)) {
      return Get.find<_RxEntiteEntreprise>(tag: CacheKey.entite.name);
    }
    final rx = Rx(EntiteEntreprise());
    Get.put<_RxEntiteEntreprise>(rx, tag: CacheKey.entite.name, permanent: true);
    return rx;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final entite = _entite.value;
      final isAtelier = entite.type == EntiteEntrepriseType.succursale;
      final libelle = entite.libelle?.trim() ?? '';

      return Pressable(
        onTap: () => CBottomSheet.show(
          isDismissible: true,
          child: const SelectEntrepriseBottomPage(),
          height: 600,
          isScrollControlled: true,
        ).then((e) {
          if (e != null) onSelectionChanged();
        }),
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 7, 12, 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isAtelier ? Icons.home_work_rounded : Icons.storefront_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const Gap(8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        libelle.isEmpty ? "Sélectionner une entreprise" : libelle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      if (libelle.isNotEmpty)
                        Text(
                          isAtelier ? "Atelier" : "Boutique",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                        ),
                    ],
                  ),
                ),
                const Gap(4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.secondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
