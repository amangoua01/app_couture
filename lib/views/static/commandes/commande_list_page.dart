import 'package:ateliya/tools/widgets/command_tile.dart';
import 'package:ateliya/tools/widgets/wrapper_listview_from_view_controller.dart';
import 'package:ateliya/views/controllers/commandes/commande_list_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommandeListPage extends StatelessWidget {
  const CommandeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commandes")),
      body: GetBuilder(
        init: CommandeListVctl(),
        builder: (ctl) {
          return WrapperListviewFromViewController(
            ctl: ctl,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
                top: 19,
              ),
              child: CommandTile(mesure: ctl.data.items[i]),
            ),
          );
        },
      ),
    );
  }
}
