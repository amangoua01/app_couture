import 'package:app_couture/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:flutter/material.dart';

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
      ],
    );
  }
}
