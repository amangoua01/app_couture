import 'package:app_couture/data/models/fichier_server.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/body_list_view.dart';
import 'package:app_couture/tools/widgets/list_item.dart';
import 'package:app_couture/views/controllers/clients/client_liste_page_vctl.dart';
import 'package:app_couture/views/static/clients/edition_client_page.dart';
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
          itemBuilder: (e, i, selected) => ListItem(
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
        );
      },
    );
  }
}
