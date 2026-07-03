import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/home/detail_boutique_item_page_vctl.dart';
import 'package:ateliya/views/static/modele/entrees_stock_list_sub_page.dart';
import 'package:ateliya/views/static/modele/reservation_list_sub_page.dart';
import 'package:ateliya/views/static/modele/vente_list_sub_page.dart';
import 'package:ateliya/tools/widgets/c_tab_bar.dart';
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
              title: Text(modele.modele?.libelle.value ?? "Détail modèle"),
            ),
            body: Column(
              children: [
                const CTabBar(tabs: ["Ventes", "Réservations", "Mouvements"]),
                Expanded(
                  child: TabBarView(
                    children: [
                      VenteListSubPage(ctl),
                      ReservationListSubPage(ctl),
                      EntreesStockListSubPage(ctl),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
