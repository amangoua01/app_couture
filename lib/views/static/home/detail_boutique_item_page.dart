import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/views/static/modeles/entrees_stock_list_sub_page.dart';
import 'package:app_couture/views/static/modeles/reservation_list_sub_page.dart';
import 'package:app_couture/views/static/modeles/vente_list_sub_page.dart';
import 'package:flutter/material.dart';

class DetailBoutiqueItemPage extends StatelessWidget {
  const DetailBoutiqueItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Détail modèle"),
          backgroundColor: AppColors.primary,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ventes"),
              Tab(text: "Réservations"),
              Tab(text: "Entrées stock"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VenteListSubPage(),
            ReservationListSubPage(),
            EntreesStockListSubPage(),
          ],
        ),
      ),
    );
  }
}
