import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter/material.dart';

class LigneCard extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final String montant;
  final bool isEntree;
  final VoidCallback? onDelete;
  const LigneCard(
      {super.key,
      required this.index,
      required this.title,
      required this.subtitle,
      required this.montant,
      required this.isEntree,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    // final line = index;
    // final isEntree = isEntree;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            montant.toAmount(unit: 'Fcfa'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isEntree ? AppColors.primary : AppColors.secondary,
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
