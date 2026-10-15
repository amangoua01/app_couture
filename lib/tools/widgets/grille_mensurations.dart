import 'package:ateliya/data/models/mensuration.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Mensurations d'un article en tuiles de taille identique, sur trois colonnes.
///
/// Des pastilles de largeur variable, qui passent à la ligne au hasard des
/// noms, se lisent mal et rendent les mesures difficiles à comparer d'un coup
/// d'œil. Ici le nom (petit) est au-dessus, la valeur (grande) dessous, et
/// chaque ligne s'aligne sur la précédente.
class GrilleMensurations extends StatelessWidget {
  final List<Mensuration> mensurations;
  const GrilleMensurations({super.key, required this.mensurations});

  @override
  Widget build(BuildContext context) {
    if (mensurations.isEmpty) {
      return Text(
        'Aucune mesure enregistrée',
        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
      );
    }

    const espace = 8.0;
    const colonnes = 3;
    return LayoutBuilder(
      builder: (context, box) {
        final largeur = (box.maxWidth - espace * (colonnes - 1)) / colonnes;
        return Wrap(
          spacing: espace,
          runSpacing: espace,
          children: [
            for (final m in mensurations)
              SizedBox(width: largeur, child: _Tuile(mensuration: m)),
          ],
        );
      },
    );
  }
}

class _Tuile extends StatelessWidget {
  final Mensuration mensuration;
  const _Tuile({required this.mensuration});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Hauteur fixe : la grille garde un rythme régulier et reste compacte
      // même avec beaucoup de mesures. Le nom tient sur deux lignes au plus.
      height: 60,
      padding: const EdgeInsets.fromLTRB(9, 7, 9, 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mensuration.categorieMesure?.libelle ?? 'Mesure',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              height: 1.15,
              fontWeight: FontWeight.w600,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
          ),
          Text(
            mensuration.taille,
            style: const TextStyle(
              fontSize: 17,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
