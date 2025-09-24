import 'package:app_couture/views/static/type_mesure/edition_type_mesure_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypeMesureListPage extends StatelessWidget {
  const TypeMesureListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Types de mesure")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const EditionTypeMesurePage()),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemCount: 4,
        itemBuilder: (_, i) => const ListTile(
          leading: CircleAvatar(),
          title: Text("Veste"),
          subtitle: Text(
            "Tour de manche, Manche, Pantalon",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
          ),
        ),
      ),
    );
  }
}
