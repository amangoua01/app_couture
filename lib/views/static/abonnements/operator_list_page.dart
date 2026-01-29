import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/data/models/operateur.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/wrapper_gridview.dart';
import 'package:ateliya/views/controllers/abonnements/operator_list_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/downgrade_selection_option_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorListPage extends StatelessWidget {
  final ModuleAbonnement forfait;
  const OperatorListPage(this.forfait, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OperatorListPageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Opérateurs"),
          ),
          body: WrapperGridview<Operateur>(
            padding: const EdgeInsets.all(20),
            isLoading: ctl.isLoading,
            onRefresh: ctl.getOperateurs,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            items: ctl.operateurs,
            itemBuilder: (e, index) => GestureDetector(
              onTap: () => Get.to(() => const DowngradeSelectionOptionPage()),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: PlaceholderBuilder(
                    condition: e.photo?.fullUrl != null,
                    builder: () {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Image.network(
                          e.photo!.fullUrl!,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
