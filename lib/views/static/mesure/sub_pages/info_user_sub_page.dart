import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoUserSubPage extends StatelessWidget {
  final EditionMesurePageVctl ctl;
  const InfoUserSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
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
          CDropDownFormField<Client>(
            selectedItem: ctl.client,
            require: true,
            items: (p0, p1) => ctl.fetchClients(),
            externalLabel: "Client",
            itemAsString: (e) => e.fullName,
            filterFn: (client, filter) {
              // Recherche par nom, prénom ou téléphone
              final searchTerm = filter.toLowerCase();
              final nom = (client.nom ?? '').toLowerCase();
              final prenom = (client.prenom ?? '').toLowerCase();
              final tel = (client.tel ?? '').toLowerCase();

              return nom.contains(searchTerm) ||
                  prenom.contains(searchTerm) ||
                  tel.contains(searchTerm);
            },
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Rechercher par nom, prénom ou téléphone...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
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
                onPressed: () => Get.to(() => const EditionClientPage()),
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
    );
  }
}
