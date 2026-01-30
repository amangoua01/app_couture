import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:ateliya/views/static/mesure/sub_pages/info_paiement_sub_page.dart';
import 'package:ateliya/views/static/mesure/sub_pages/info_user_sub_page.dart';
import 'package:ateliya/views/static/mesure/sub_pages/list_piece_sub_page.dart';
import 'package:ateliya/views/static/mesure/sub_pages/recap_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionMesurePage extends StatelessWidget {
  const EditionMesurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionMesurePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Ajouter une mesure")),
          bottomNavigationBar: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Précédent"),
                      onPressed: ctl.previousPage,
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: TextButton.icon(
                      iconAlignment: IconAlignment.end,
                      icon: Icon(
                        ternaryFn(
                          condition: ctl.page + 1 == ctl.pages.length,
                          ifTrue: Icons.check,
                          ifFalse: Icons.arrow_forward,
                        ),
                      ),
                      label: Text(
                        ternaryFn(
                          condition: ctl.page + 1 == ctl.pages.length,
                          ifTrue: "Valider",
                          ifFalse: "Suivant",
                        ),
                      ),
                      onPressed: ctl.nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 20, top: 15),
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: AppColors.yellow,
                            backgroundColor: AppColors.ligthGrey,
                            value: (ctl.page + 1) / 3,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${ctl.page + 1}/${ctl.pages.length}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  ctl.pages[ctl.page].title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(ctl.pages[ctl.page].subtitle),
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: ctl.pageCtl,
                  onPageChanged: (e) {
                    ctl.page = e;
                    ctl.update();
                  },
                  children: [
                    InfoUserSubPage(ctl),
                    ListPieceSubPage(ctl),
                    InfoPaiementSubPage(ctl),
                    RecapSubPage(ctl),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
