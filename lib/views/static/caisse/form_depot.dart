import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/constants/sens_mouvement_caisse_enum.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/caisse/approvisionner_caisse_page_vctl.dart';
import 'package:flutter/material.dart';

class FormDepot extends StatelessWidget {
  final ApprovisionnerCaissePageVctl ctl;
  const FormDepot({super.key, required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CDropDownFormField<ModePaiementEnum>(
            externalLabel: "Mode de paiement",
            selectedItem: ctl.modePaiement,
            items: (filter, loadProps) async => ModePaiementEnum.values,
            itemAsString: (item) => item.label,
            onChanged: (e) {
              if (e != null) {
                ctl.modePaiement = e;
                ctl.update();
              }
            },
          ),
          CDropDownFormField<SensMouvementCaisseEnum>(
            externalLabel: "Sens",
            selectedItem: ctl.sens,
            enabled: false,
            fillColor: Colors.grey.shade100,
            items: (filter, loadProps) async => SensMouvementCaisseEnum.values,
            itemAsString: (item) => item.label,
            onChanged: (e) {
              if (e != null) {
                ctl.sens = e;
                ctl.update();
              }
            },
          ),
          CTextFormField(
            externalLabel: "Description",
            controller: ctl.descriptionCtl,
            maxLines: 2,
            margin: EdgeInsets.zero,
            hintText: "Saisir une description (facultatif)",
          ),
        ],
      ),
    );
  }
}
