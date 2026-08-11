import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/views/controllers/modele_boutique/modele_boutique_list_page_vctl.dart';
import 'package:ateliya/views/static/modele_boutique/edition_modele_boutique_page.dart';
import 'package:ateliya/views/static/ravitaillement/edition_ravitaillement_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeleListBoutiquePage extends StatelessWidget {
  const ModeleListBoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ModeleBoutiqueListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Modèles boutique",
          createPage: const EditionModeleBoutiquePage(),
          itemBuilder:
              (_, i, selected) => ListItem(
                ctl,
                leadingImage:
                    (ctl.data.items[i].modele!.photo == null)
                        ? "assets/images/svg/modele.svg"
                        : (ctl.data.items[i].modele!.photo is FichierServer)
                        ? (ctl.data.items[i].modele!.photo as FichierServer)
                            .fullUrl!
                        : null,
                editionPage: EditionModeleBoutiquePage(item: ctl.data.items[i]),
                index: i,
                title: ctl.data.items[i].modele!.libelle.value,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(ctl.data.items[i].quantite.toAmount(unit: "unité(s)")),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.qr_code_2_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            ctl.data.items[i].codeBarre?.isNotEmpty == true
                                ? ctl.data.items[i].codeBarre!
                                : "Aucun code barre",
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  ctl.data.items[i].codeBarre?.isNotEmpty ==
                                          true
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade400,
                              fontStyle:
                                  ctl.data.items[i].codeBarre?.isNotEmpty ==
                                          true
                                      ? FontStyle.normal
                                      : FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  PopupMenuItem(
                    child: const Text("Ravitailler"),
                    onTap: () async {
                      final res = await Get.to(
                        () => EditionRavitaillementPage.one(ctl.data.items[i]),
                      );
                      if (res != null) {
                        ctl.getList();
                      }
                    },
                  ),
                  PopupMenuItem(
                    enabled: ctl.data.items[i].codeBarre.value.isNotEmpty,
                    child: const Text("Imprimer étiquette"),
                    onTap: () => ctl.printBarcodeLabel(ctl.data.items[i]),
                  ),
                ],
              ),
        );
      },
    );
  }
}
