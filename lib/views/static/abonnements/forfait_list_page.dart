import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/abonnements/forfait_list_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/detail_forfait_sub_page.dart';
import 'package:ateliya/views/static/abonnements/operator_list_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ForfaitListPage extends StatelessWidget {
  const ForfaitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ForfaitListPageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Forfaits")),
          body: WrapperListview(
            isLoading: ctl.isLoading,
            items: ctl.forfaits,
            onRefresh: ctl.getForfaits,
            padding: const EdgeInsets.all(20),
            itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 215,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ctl.forfaits[i].code.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          ctl.forfaits[i].montant.toAmount(unit: "Fcfa"),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_month_sharp,
                            color: Colors.green),
                        const Gap(10),
                        Expanded(
                          child: Text(
                            "Valable ${ctl.forfaits[i].duree.toAmount(unit: "mois")}",
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      ctl.forfaits[i].description.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () => CBottomSheet.show(
                            child: DetailForfaitSubPage(ctl.forfaits[i]),
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: AppColors.primary.withAlpha(40),
                          child: const Text("Voir détails"),
                        ),
                        const Gap(10),
                        MaterialButton(
                          onPressed: () => Get.to(
                            () => OperatorListPage(ctl.forfaits[i]),
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: AppColors.primary.withAlpha(40),
                          child: const Text("Payer"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
