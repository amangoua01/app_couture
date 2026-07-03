import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/sens_mouvement_caisse_enum.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/caisse/approvisionner_caisse_page_vctl.dart';
import 'package:flutter/material.dart';

class LigneDepotCard extends StatelessWidget {
  final int index;
  final ApprovisionnerCaissePageVctl ctl;
  const LigneDepotCard({super.key, required this.index, required this.ctl});

  @override
  Widget build(BuildContext context) {
    final line = ctl.lines[index];
    final isEntree = ctl.sens == SensMouvementCaisseEnum.entree;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        line.caisse!.entite!.libelle.value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        "${ctl.sens.label.value} • ${ctl.modePaiement.label.value}",
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            line.montantCtl.text.toAmount(unit: 'Fcfa'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isEntree ? AppColors.primary : AppColors.secondary,
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: () => ctl.removeLine(index),
          ),
        ],
      ),
    );
  }
}
