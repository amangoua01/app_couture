import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/views/controllers/boutiques/edition_boutique_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class EditionBoutiquePage extends StatelessWidget {
  const EditionBoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionBoutiquePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Edition de boutique")),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CTextFormField(
                  externalLabel: "Nom",
                  controller: ctl.nomCtl,
                  require: true,
                ),
                CTextFormField(
                  externalLabel: "Contact",
                  controller: ctl.contactCtl,
                  require: true,
                  keyboardType: TextInputType.phone,
                ),
                CTextFormField(
                  externalLabel: "Situation géographique",
                  controller: ctl.situationCtl,
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
