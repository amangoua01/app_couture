import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/photo_produit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Composants partagés par les écrans de vente et de réservation.

class SectionTitre extends StatelessWidget {
  final String label;
  const SectionTitre(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: AppColors.primary.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

/// Rappel de l'article vendu : on sait d'un coup d'œil ce qu'on vend, sa
/// taille et ce qu'il en reste, au lieu d'un champ grisé illisible.
class ArticleCard extends StatelessWidget {
  final ModeleBoutique item;
  const ArticleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final photo = item.modele?.photo;
    final url = photo is FichierServer ? photo.fullUrl : null;
    final stock = item.quantite ?? 0;
    final taille =
        (item.taille == null || item.taille!.isEmpty) ? null : item.taille;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 68,
              height: 68,
              child: PhotoProduit(
                url: url,
                largeurAffichee: 68,
                placeholder: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Image.asset('assets/images/model1.png'),
                ),
              ),
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.modele?.libelle.value ?? 'Article',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (taille != null) Pastille("Taille $taille"),
                    Pastille(
                      stock > 0 ? "$stock en stock" : "Rupture",
                      alerte: stock <= 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Pastille extends StatelessWidget {
  final String label;
  final bool alerte;
  const Pastille(this.label, {this.alerte = false});

  @override
  Widget build(BuildContext context) {
    final color = alerte ? AppColors.secondary : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class ClientTile extends StatelessWidget {
  final Client client;
  final bool isSelected;
  const ClientTile({required this.client, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final nom = client.fullName.trim();
    final initiale = nom.isEmpty ? '?' : nom[0].toUpperCase();
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.06),
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          initiale,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
      title: Text(
        nom,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle:
          (client.tel ?? '').isEmpty
              ? null
              : Text(client.tel!, style: const TextStyle(fontSize: 12.5)),
      trailing:
          isSelected
              ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
              : null,
    );
  }
}

class PaiementTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  const PaiementTile({required this.label, required this.isSelected});

  static IconData _icone(ModePaiementEnum mode) {
    switch (mode) {
      case ModePaiementEnum.especes:
        return Icons.payments_outlined;
      case ModePaiementEnum.autre:
        return Icons.more_horiz_rounded;
      default:
        return Icons.smartphone_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ModePaiementEnum.fromLabel(label);
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.06),
      leading: Icon(_icone(mode), color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing:
          isSelected
              ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
              : null,
    );
  }
}

class PasBouton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const PasBouton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 50,
          height: 50,
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}
