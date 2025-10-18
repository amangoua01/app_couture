import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/extensions/types/int.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/commandes/command_group_card.dart';
import 'package:app_couture/tools/widgets/commandes/command_listtile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DetailCommandPage extends StatelessWidget {
  const DetailCommandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détail de la commande")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CommandGroupCard(
            children: [
              const Gap(10),
              Text('${(50 * 0.5).toInt()} %'),
              const Gap(10),
              LinearProgressIndicator(
                color: AppColors.primary,
                value: 0.5,
                minHeight: 15,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: AppColors.primary.withAlpha(100),
              ),
              const Gap(10),
              const Row(
                children: [
                  Expanded(
                    child: Text("10 000 FCFA"),
                  ),
                  Text(
                    "10 000 FCFA",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              const CommandListtile(
                title: 'Avance',
                value: '10 000 FCFA',
              ),
              const CommandListtile(
                title: 'Montant restant',
                value: '1 000 FCFA',
              ),
              const CommandListtile(
                title: 'Montant restant',
                value: '1 000 FCFA',
              ),
            ],
          ),
          CommandGroupCard(
            title: 'Articles',
            children: List.generate(
              10,
              (i) => CommandListtile(
                title: '$i Article',
                value: (1000 * i).toAmount(unit: 'F'),
              ),
            ),
          ),
          const CommandGroupCard(
            title: 'Client',
            children: [
              CommandListtile(
                title: 'Nom',
                value: 'John Doe',
              ),
              CommandListtile(
                title: 'Numéro de téléphone',
                value: '123456789',
              ),
            ],
          ),
          const Gap(20),
          CButton(title: 'Télécharger le reçu', onPressed: () {}),
          const Gap(20),
        ],
      ),
    );
  }
}
