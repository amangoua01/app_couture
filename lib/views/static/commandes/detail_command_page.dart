import 'package:flutter/material.dart';

class DetailCommandPage extends StatelessWidget {
  const DetailCommandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détail de la commande")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [],
      ),
    );
  }
}
