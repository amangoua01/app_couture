import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/shimmer_listtile.dart';
import 'package:ateliya/views/controllers/depense/types_depense_list_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Gestion des types de dépense : les types globaux (définis par Ateliya,
/// communs à tous) et les types personnalisés que l'entreprise crée pour
/// ses propres besoins.
class TypesDepenseListPage extends StatelessWidget {
  const TypesDepenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TypesDepenseListVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(title: const Text("Types de dépense")),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateSheet(context, ctl),
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: ctl.fetchTypes,
            child: PlaceholderWidget(
              condition: !ctl.isLoading,
              placeholder: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: 6,
                itemBuilder: (_, __) => const ShimmerListtile(),
              ),
              child: PlaceholderWidget(
                condition: ctl.types.isNotEmpty,
                placeholder: const EmptyDataWidget(
                  message: "Aucun type de dépense pour l'instant",
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: ctl.types.length,
                  itemBuilder: (_, i) {
                    final type = ctl.types[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.15),
                          width: 1.5,
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.category_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const Gap(14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    type.libelle ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: Color(0xFF0F231F),
                                    ),
                                  ),
                                  const Gap(6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          type.isGlobal
                                              ? Colors.grey.shade100
                                              : AppColors.primary.withOpacity(
                                                0.1,
                                              ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      type.isGlobal ? "Global" : "Personnalisé",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color:
                                            type.isGlobal
                                                ? Colors.grey.shade600
                                                : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!type.isGlobal)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                  size: 22,
                                ),
                                onPressed: () => ctl.deleteType(type),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCreateSheet(BuildContext context, TypesDepenseListVctl ctl) {
    final libelleCtl = TextEditingController();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(16),
            const Text(
              "Nouveau type de dépense",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Gap(16),
            CTextFormField(
              controller: libelleCtl,
              externalLabel: "Libellé",
              hintText: "Ex: Entretien véhicule",
              autofocus: true,
              require: true,
              margin: const EdgeInsets.only(bottom: 20),
            ),
            CButton(
              title: "Créer",
              onPressed: () {
                if (libelleCtl.text.trim().isEmpty) return;
                ctl.createType(libelleCtl.text.trim());
                Get.back();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
