import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:ateliya/views/static/mesure/edition_mensuration_page.dart';
import 'package:ateliya/views/static/mesure/edition_piece_couture_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:signature/signature.dart';

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
                    Form(
                      key: ctl.formKey1,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          CDateFormField(
                            controller: ctl.dateRetraitCtl,
                            externalLabel: "Date de retrait",
                            withTime: true,
                            require: true,
                            firstDate: DateTime.now(),
                            onChange: (e) {
                              ctl.dateRetraitCtl.dateTime = e;
                              ctl.update();
                            },
                          ),
                          CDropDownFormField(
                            selectedItem: ctl.client,
                            require: true,
                            items: (p0, p1) => ctl.fetchClients(),
                            externalLabel: "Client",
                            itemAsString: (e) => e.fullName,
                            onChanged: (e) {
                              ctl.client = e;
                              ctl.contactClientCtl.text = e!.tel.value;
                              ctl.update();
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    Get.to(() => const EditionClientPage()),
                                label: const Text("Ajouter un client"),
                              )
                            ],
                          ),
                          CTextFormField(
                            controller: ctl.contactClientCtl,
                            enabled: ctl.client != null,
                            require: true,
                            externalLabel: "Contact client",
                          ),
                        ],
                      ),
                    ),
                    Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () async {
                          final res = await Get.to(
                            () => const EditionPieceCouturePage(),
                          );
                          if (res is LigneMesureDto) {
                            ctl.mesure.lignesMesures.add(res);
                            ctl.update();
                          }
                        },
                        child: const Icon(Icons.add),
                      ),
                      body: WrapperListview(
                        items: ctl.mesure.lignesMesures,
                        padding: const EdgeInsets.all(20),
                        itemBuilder: (e, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red.withAlpha(100),
                              child: IconButton(
                                color: Colors.red,
                                onPressed: () async {
                                  final rep = await CChoiceMessageDialog.show(
                                    message: "Voulez-vous vraiment"
                                        " supprimer cette pièce ?",
                                  );
                                  if (rep == true) {
                                    ctl.mesure.lignesMesures.remove(e);
                                    ctl.update();
                                  }
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              e.libelle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(e.getCalcul),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  child: CircleAvatar(
                                    child: SvgPicture.asset(
                                      "assets/images/svg/measure_meter.svg",
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                  onTap: () async {
                                    final res = await Get.to(
                                      () => EditionMensurationPage(e),
                                    );
                                    if (res is List<MensurationDto>) {
                                      e.typeMesureDto!.mensurations = res;
                                      ctl.update();
                                    }
                                  },
                                ),
                                const Gap(20),
                                const Icon(Icons.arrow_forward_ios, size: 20)
                              ],
                            ),
                            onTap: () async {
                              final res = await Get.to(
                                () => EditionPieceCouturePage(ligne: e),
                              );
                              if (res is LigneMesureDto) {
                                ctl.mesure.lignesMesures[index] = res;
                                ctl.update();
                              }
                            },
                          );
                        },
                      ),
                    ),
                    ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const CTextFormField(externalLabel: "Avance"),
                        const CTextFormField(externalLabel: "Remise globale"),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Signature du client",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: ctl.signatureCtl.clear,
                                  label: const Text("Effacer"),
                                  icon: const Icon(
                                    IcoFontIcons.eraser,
                                    size: 17,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(7),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              height: 250,
                              child: Signature(
                                controller: ctl.signatureCtl,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const Gap(40),
                          ],
                        ),
                      ],
                    ),
                    ListView(),
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
