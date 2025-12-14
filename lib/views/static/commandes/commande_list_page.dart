import 'package:ateliya/tools/widgets/command_tile.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:flutter/material.dart';

class CommandeListPage extends StatelessWidget {
  const CommandeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commandes")),
      body: WrapperListview(
        padding: const EdgeInsets.all(20),
        items: const [1, 2, 3],
        itemBuilder: (_, i) => const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: CommandTile(),
        ),
      ),
    );
  }
}
