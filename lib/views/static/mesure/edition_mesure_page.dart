import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
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
    return GetBuilder<EditionMesurePageVctl>(
      init: EditionMesurePageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text("Nouvelle commande"),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (ctl.page > 0)
                    TextButton.icon(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      label: const Text("Précédent"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onPressed: ctl.previousPage,
                    ),
                  const Spacer(),
                  SizedBox(
                    width: 130,
                    child: CButton(
                      title: ctl.page + 1 == ctl.pages.length
                          ? "Valider"
                          : "Suivant",
                      onPressed: ctl.nextPage,
                      color: AppColors.primary,
                      icon: Icon(
                        ctl.page + 1 == ctl.pages.length
                            ? Icons.check
                            : Icons.arrow_forward,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              // Custom Stepper
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(ctl.pages.length, (index) {
                      final isActive = index == ctl.page;
                      final isPast = index < ctl.page;
                      final isLast = index == ctl.pages.length - 1;

                      return Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isActive ? 32 : 28,
                            height: isActive ? 32 : 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive || isPast
                                  ? AppColors.primary
                                  : Colors.grey[200],
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4))
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: isPast
                                  ? const Icon(Icons.check,
                                      size: 16, color: Colors.white)
                                  : Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: isActive || isPast
                                            ? Colors.white
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          if (isActive) ...[
                            const Gap(8),
                            Text(
                              ctl.pages[index].title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 13),
                            ),
                          ],
                          if (!isLast)
                            Container(
                              width: isActive ? 15 : 25,
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              color: isPast
                                  ? AppColors.primary.withValues(alpha: 0.5)
                                  : Colors.grey[200],
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

              // Contenu principal
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
