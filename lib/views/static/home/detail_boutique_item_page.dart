import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DetailBoutiqueItemPage extends StatelessWidget {
  const DetailBoutiqueItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail modèle"),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
