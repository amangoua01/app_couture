import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mesure/reprendre_mesures_client_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:date_format/date_format.dart';

class ReprendreMesuresClientPage extends StatelessWidget {
  const ReprendreMesuresClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ReprendreMesuresClientPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(
            title: const Text("Reprendre les mesures d'un client"),
            leading:
                ctl.selectedClient != null
                    ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: ctl.clearSelection,
                    )
                    : null,
          ),
          body:
              ctl.selectedClient == null
                  ? _ClientSearchView(ctl: ctl)
                  : _ClientHistoryView(ctl: ctl),
        );
      },
    );
  }
}

class _ClientSearchView extends StatelessWidget {
  final ReprendreMesuresClientPageVctl ctl;
  const _ClientSearchView({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CTextFormField(
            hintText: "Nom ou numéro du client...",
            prefixIcon: const Icon(Icons.search_rounded),
            autofocus: true,
            onChanged: ctl.onSearchChanged,
          ),
          const Gap(16),
          Expanded(
            child:
                ctl.searchText.trim().isEmpty
                    ? const EmptyPage(
                      icon: Icons.history_rounded,
                      title: "Recherchez un client",
                      subtitle:
                          "Tapez un nom ou un numéro pour retrouver ses pièces déjà cousues.",
                    )
                    : ctl.filteredClients.isEmpty
                    ? const EmptyPage(
                      icon: Icons.person_off_rounded,
                      title: "Aucun client trouvé",
                      subtitle: "Vérifiez l'orthographe ou le numéro saisi.",
                    )
                    : ListView.separated(
                      itemCount: ctl.filteredClients.length,
                      separatorBuilder: (_, i) => const Gap(10),
                      itemBuilder: (_, i) {
                        final client = ctl.filteredClients[i];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => ctl.selectClient(client),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: CardStyle.decoration(),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: CardStyle.pastel(AppColors.primary),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    client.fullName.isNotEmpty
                                        ? client.fullName[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        client.fullName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (client.tel.value.isNotEmpty)
                                        Text(
                                          client.tel.value,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class _ClientHistoryView extends StatelessWidget {
  final ReprendreMesuresClientPageVctl ctl;
  const _ClientHistoryView({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: CardStyle.decoration(),
          child: Row(
            children: [
              const Icon(Icons.person_rounded, color: AppColors.primary),
              const Gap(10),
              Expanded(
                child: Text(
                  ctl.selectedClient!.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              ctl.isLoadingHistory
                  ? const Center(child: CircularProgressIndicator())
                  : ctl.loadError != null
                  ? EmptyPage(
                    icon: Icons.cloud_off_rounded,
                    title: "Échec du chargement",
                    subtitle: ctl.loadError!,
                  )
                  : ctl.pieces.isEmpty
                  ? const EmptyPage(
                    icon: Icons.inventory_2_outlined,
                    title: "Aucun historique",
                    subtitle: "Ce client n'a pas encore de pièce enregistrée.",
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: ctl.pieces.length,
                    separatorBuilder: (_, i) => const Gap(10),
                    itemBuilder: (_, i) {
                      final item = ctl.pieces[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: CardStyle.decoration(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.piece.typeMesure?.libelle.value ??
                                        "Pièce",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    item.date != null
                                        ? formatDate(item.date!, [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                        ])
                                        : "Date inconnue",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    item.piece.mensurations.isEmpty
                                        ? "Taille standard"
                                        : "${item.piece.mensurations.length} mensurations enregistrées",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed:
                                  () => Get.back(
                                    result: ctl.buildDtoFrom(item.piece),
                                  ),
                              child: const Text(
                                "Reconduire",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
