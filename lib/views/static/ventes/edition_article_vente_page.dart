import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionArticleVentePage extends StatelessWidget {
  const EditionArticleVentePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Article de vente")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CDropDownFormField(
            externalLabel: "Article",
          ),
          const CTextFormField(
            externalLabel: "Prix unitaire",
          ),
          const CTextFormField(
            externalLabel: "Quantité",
          ),
          const Gap(30),
          CButton(
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }
}
