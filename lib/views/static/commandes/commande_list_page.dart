import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/command_tile.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/views/controllers/commandes/commande_list_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommandeListPage extends StatelessWidget {
  const CommandeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GetBuilder<CommandeListVctl>(
        init: CommandeListVctl(),
        builder: (ctl) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Commandes"),
              bottom: TabBar(
                isScrollable: true,
                onTap: (index) {
                  ctl.tabIndex = index;
                  ctl.update();
                },
                tabs: const [
                  Tab(text: "Non terminées"),
                  Tab(text: "Soldées non term."),
                  Tab(text: "Terminées"),
                ],
              ),
              actions: [
                if (!ctl.isLoading)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: ctl.getList,
                  ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => CBottomSheet.show(
                child: GetBuilder<CommandeListVctl>(
                  init: ctl,
                  builder: (_) => _FilterSheet(ctl: ctl),
                ),
              ),
              backgroundColor: AppColors.primary,
              child: SvgPicture.asset(
                'assets/images/svg/filter.svg',
                height: 22,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            body: PlaceholderBuilder(
              condition: !ctl.isLoading,
              placeholder: const Center(child: CircularProgressIndicator()),
              builder: () {
                final items = ctl.items;
                if (items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: ctl.getList,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        alignment: Alignment.center,
                        child: EmptyDataWidget(
                          message: "Aucune commande trouvée",
                          onRefresh: ctl.getList,
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: ctl.getList,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 100,
                      top: 15,
                    ),
                    itemCount: ctl.items.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: CommandTile(mesure: ctl.items[i]),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// class _TabList extends StatelessWidget {
//   final List<Mesure> items;
//   final Future<void> Function() onRefresh;

//   const _TabList({required this.items, required this.onRefresh});

//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) {
//       return RefreshIndicator(
//         onRefresh: onRefresh,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.7,
//             alignment: Alignment.center,
//             child: EmptyDataWidget(
//               message: "Aucune commande trouvée",
//               onRefresh: onRefresh,
//             ),
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: ListView.builder(
//         padding:
//             const EdgeInsets.only(left: 15, right: 15, bottom: 100, top: 15),
//         itemCount: items.length,
//         itemBuilder: (_, i) => Padding(
//           padding: const EdgeInsets.only(bottom: 15),
//           child: CommandTile(mesure: items[i]),
//         ),
//       ),
//     );
//   }
// }

class _FilterSheet extends StatelessWidget {
  final CommandeListVctl ctl;
  const _FilterSheet({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      children: [
        Row(
          children: [
            const Icon(Icons.filter_list_rounded,
                color: AppColors.primary, size: 20),
            const Gap(8),
            const Text(
              'Filtrer les commandes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                ctl.resetFilters();
                Get.back();
              },
              child: const Text('Réinitialiser',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ],
        ),
        const Divider(height: 20),
        CDateFormField(
          labelText: 'Date de début',
          controller: ctl.dateDebut,
          withTime: false,
          onClear: () {
            ctl.dateDebut.clear();
            ctl.update();
          },
          onChange: (e) {
            ctl.dateDebut.dateTime = e;
            ctl.update();
          },
        ),
        CDateFormField(
          labelText: 'Date de fin',
          controller: ctl.dateFin,
          withTime: false,
          onClear: () {
            ctl.dateFin.clear();
            ctl.update();
          },
          onChange: (e) {
            ctl.dateFin.dateTime = e;
            ctl.update();
          },
        ),
        const Gap(10),
        CTextFormField(
          controller: ctl.nomClientCtrl,
          externalLabel: 'Nom du client',
        ),
        CTextFormField(
          controller: ctl.numeroClientCtrl,
          externalLabel: 'Numéro de téléphone',
        ),
        const Gap(10),
        // Dropdown pour état facture
        DropdownButtonFormField<String>(
          value: ctl.etatFacture,
          decoration: const InputDecoration(
            labelText: 'État de la commande (facture)',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          items: const [
            DropdownMenuItem(value: null, child: Text('Tous (Toutes dates)')),
            DropdownMenuItem(value: 'EN_COURS', child: Text('En cours')),
            DropdownMenuItem(
                value: 'NON_COMMENCE', child: Text('Non commencé')),
            DropdownMenuItem(value: 'TERMINE', child: Text('Terminé')),
            DropdownMenuItem(value: 'SOLDE', child: Text('Soldé')),
          ],
          onChanged: (v) {
            ctl.etatFacture = v;
            ctl.update();
          },
        ),
        const Gap(20),
        CButton(
          title: 'Appliquer',
          onPressed: () {
            ctl.getList();
            Get.back();
          },
        ),
      ],
    );
  }
}
