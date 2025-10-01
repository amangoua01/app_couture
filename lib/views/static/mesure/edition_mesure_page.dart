import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/extensions/ternary_fn.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_date_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:app_couture/views/static/clients/edition_client_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            color: AppColors.yellow,
                            backgroundColor: AppColors.ligthGrey,
                            value: (ctl.page + 1) / 3,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${ctl.page + 1}/3",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 19,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  ctl.pages[ctl.page]["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(ctl.pages[ctl.page]["subtitle"]!),
              ),
              Expanded(
                child: PageView(
                  onPageChanged: (e) {
                    ctl.page = e;
                    ctl.update();
                  },
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const CDropDownFormField(externalLabel: "Client"),
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
                      ],
                    ),
                    ListView(
                      padding: const EdgeInsets.all(20),
                      children: const [
                        CTextFormField(externalLabel: "Libellé"),
                      ],
                    ),
                    ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        CDateFormField(
                          labelText: "Date de retrait",
                          onChange: (e) {},
                        ),
                        const CTextFormField(externalLabel: "Total"),
                        const CTextFormField(externalLabel: "Avance"),
                        const CTextFormField(externalLabel: "Remise"),
                        SizedBox(
                          height: 200,
                          child: Signature(
                            controller: ctl.signatureCtl,
                          ),
                        ),
                        CButton(
                          onPressed: () {
                            ctl.signatureCtl.undo();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CButton(
                    title: ternaryFn(
                      condition: ctl.page == 2,
                      ifTrue: "Enregistrer",
                      ifFalse: "Suivant",
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
