import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditionEntreeStock extends StatelessWidget {
  final bool isEntreeStock;
  const EditionEntreeStock({required this.isEntreeStock, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        CDropDownFormField(externalLabel: 'Article'),
        CTextFormField(externalLabel: "Quantité"),
        Gap(20),
        CButton(),
      ],
    );
  }
}
