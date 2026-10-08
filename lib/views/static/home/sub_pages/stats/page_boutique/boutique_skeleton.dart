import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

/// Chargement de la boutique, sous la forme même du contenu attendu.
///
/// Un simple rond qui tourne au centre ne dit rien de ce qui arrive et fait
/// paraître l'attente plus longue. Reprendre la silhouette d'une fiche modèle
/// suivie de sa grille de variantes annonce la structure à venir et évite le
/// saut visuel au moment où les données s'affichent.
class BoutiqueSkeleton extends StatelessWidget {
  const BoutiqueSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        children: [
          for (var i = 0; i < 2; i++) ...[
            const _CarteModeleFactice(),
            const Gap(10),
            const Row(
              children: [
                Expanded(child: _CarteVarianteFactice()),
                Gap(10),
                Expanded(child: _CarteVarianteFactice()),
              ],
            ),
            const Gap(16),
          ],
        ],
      ),
    );
  }
}

class _Bloc extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _Bloc({required this.width, required this.height, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _CarteModeleFactice extends StatelessWidget {
  const _CarteModeleFactice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Bloc(width: 46, height: 46, radius: 12),
              Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bloc(width: 120, height: 13),
                  Gap(7),
                  _Bloc(width: 86, height: 16, radius: 20),
                ],
              ),
            ],
          ),
          Gap(14),
          Row(
            children: [
              _Bloc(width: 34, height: 8),
              Gap(10),
              _Bloc(width: 52, height: 21, radius: 7),
              Gap(5),
              _Bloc(width: 52, height: 21, radius: 7),
            ],
          ),
          Gap(7),
          Row(
            children: [
              _Bloc(width: 34, height: 8),
              Gap(10),
              _Bloc(width: 74, height: 21, radius: 7),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarteVarianteFactice extends StatelessWidget {
  const _CarteVarianteFactice();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bloc(width: double.infinity, height: 150, radius: 16),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bloc(width: 70, height: 13),
                Gap(6),
                _Bloc(width: 54, height: 10),
                Gap(8),
                _Bloc(width: 86, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// État vide de la boutique, avec l'action qui permet d'en sortir.
///
/// « Tirez vers le bas pour actualiser » ne sert à rien quand la boutique est
/// bel et bien vide : ce qu'il faut alors, c'est la remplir.
class BoutiqueVide extends StatelessWidget {
  final VoidCallback? onRavitailler;
  const BoutiqueVide({super.key, this.onRavitailler});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_outlined,
              size: 42,
              color: AppColors.primary,
            ),
          ),
          const Gap(22),
          const Text(
            "Votre boutique est vide",
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.3,
            ),
          ),
          const Gap(8),
          Text(
            "Ajoutez du stock pour commencer à vendre. "
            "Vos articles et leurs variantes apparaîtront ici.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Colors.grey[600],
            ),
          ),
          if (onRavitailler != null) ...[
            const Gap(22),
            ElevatedButton.icon(
              onPressed: onRavitailler,
              icon: const Icon(Icons.add_rounded, size: 19),
              label: const Text("Ravitailler la boutique"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                textStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Recherche sans résultat : la boutique n'est pas vide, c'est le filtre qui
/// ne laisse rien passer. Proposer un ravitaillement ici serait un contresens.
class BoutiqueAucunResultat extends StatelessWidget {
  final VoidCallback onEffacer;
  const BoutiqueAucunResultat({super.key, required this.onEffacer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 38,
              color: AppColors.secondary,
            ),
          ),
          const Gap(20),
          const Text(
            "Aucun article trouvé",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.3,
            ),
          ),
          const Gap(8),
          Text(
            "Essayez un autre modèle, une autre taille ou un autre prix.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Colors.grey[600],
            ),
          ),
          const Gap(16),
          TextButton.icon(
            onPressed: onEffacer,
            icon: const Icon(Icons.close_rounded, size: 17),
            label: const Text("Effacer la recherche"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.06),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 11,
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
