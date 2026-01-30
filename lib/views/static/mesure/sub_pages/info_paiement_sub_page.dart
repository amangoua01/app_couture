import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:signature/signature.dart';

class InfoPaiementSubPage extends StatelessWidget {
  final EditionMesurePageVctl ctl;
  const InfoPaiementSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: ctl.formKeyPaiement,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CTextFormField(
            externalLabel: "Avance",
            controller: ctl.avanceCtl,
            validator: (e) {
              if (e.toDouble().value >
                  (ctl.mesure.montantTotal -
                      ctl.remiseGlobaleCtl.toDouble().value)) {
                return "L'avance ne peut pas exceder le montant total";
              }
              return null;
            },
          ),
          CTextFormField(
            externalLabel: "Remise globale",
            controller: ctl.remiseGlobaleCtl,
            validator: (e) {
              if (e.toDouble().value > ctl.mesure.montantTotal) {
                return "La remise globale ne peut pas exceder le montant total";
              }
              return null;
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Signature du client",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
