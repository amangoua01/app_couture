import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/detail_boutique_item_page_vctl.dart';
import 'package:ateliya/views/static/modele/entrees_stock_list_sub_page.dart';
import 'package:ateliya/views/static/modele/reservation_list_sub_page.dart';
import 'package:ateliya/views/static/modele/vente_list_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailBoutiqueItemPage extends StatelessWidget {
  final ModeleBoutique modele;
  const DetailBoutiqueItemPage(this.modele, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GetBuilder(
        init: DetailBoutiqueItemPageVctl(modele),
        builder: (ctl) {
          return Scaffold(
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
            body: TabBarView(
              children: [
                VenteListSubPage(ctl),
                ReservationListSubPage(ctl),
                EntreesStockListSubPage(ctl),
              ],
            ),
          );
        },
      ),
    );
  }
}
