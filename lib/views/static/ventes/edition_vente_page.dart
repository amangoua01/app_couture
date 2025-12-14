import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/static/clients/edition_client_page.dart';
import 'package:ateliya/views/static/ventes/edition_article_vente_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionVentePage extends StatelessWidget {
  const EditionVentePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text("Création de vente")),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {},
                  label: const Text('Précédent'),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  iconAlignment: IconAlignment.end,
                  onPressed: () {},
                  label: const Text('Suivant'),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CDateFormField(onChange: (e) {}),
                const CDropDownFormField(externalLabel: "Client"),
                GestureDetector(
                  onTap: () => Get.to(() => const EditionClientPage()),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Text(
                        'Ajouter un client',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Scaffold(
              floatingActionButton: Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: FloatingActionButton(
                  onPressed: () =>
                      Get.to(() => const EditionArticleVentePage()),
                  child: const Icon(Icons.add),
                ),
              ),
              body: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.calculate,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text("Total"),
                    trailing: Text("1000".toAmount(unit: 'F')),
                  ),
                  const Divider(),
                  Expanded(
                    child: WrapperListview(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemBuilder: (_, i) => ListTile(
                        leading: const CircleAvatar(),
                        title: const Text("Article 1"),
                        subtitle: const Text("2 X 1 000"),
                        trailing: Text("1000".toAmount(unit: 'F')),
                      ),
                      items: const [1, 1, 2, 3],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
