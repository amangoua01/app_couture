import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/clients/client_liste_page_vctl.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientListePage extends StatelessWidget {
  const ClientListePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ClientListePageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Clients",
          createPage: const EditionClientPage(),
          itemBuilder: (e, i, selected) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.primary.withOpacity(0.15), width: 1.5),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListItem(
                ctl,
                leadingImage: (ctl.data.items[i].photo == null)
                    ? "assets/images/svg/client.svg"
                    : (ctl.data.items[i].photo is FichierServer)
                        ? (ctl.data.items[i].photo as FichierServer).fullUrl!
                        : null,
                editionPage: EditionClientPage(item: ctl.data.items[i]),
                index: i,
                title: ctl.data.items[i].fullName,
                subtitle: ctl.data.items[i].tel.value,
                selected: selected,
              ),
            ),
          ),
        );
      },
    );
  }
}
