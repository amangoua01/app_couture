import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/controllers/sucursales/edition_surcusale_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionSurcusalePage extends StatelessWidget {
  const EditionSurcusalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionSurcusalePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Edition de surcusale")),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CTextFormField(
                  externalLabel: "Nom",
                  require: true,
                  controller: ctl.libelleCtl,
                ),
                CTextFormField(
                  externalLabel: "Contact",
                  controller: ctl.contactCtl,
                ),
                const Gap(10),
                CButton(onPressed: ctl.submit)
              ],
            ),
          ),
        );
      },
    );
  }
}
