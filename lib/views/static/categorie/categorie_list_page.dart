import 'package:app_couture/views/static/categorie/edition_categorie_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorieListPage extends StatelessWidget {
  const CategorieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catégories")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const EditionCategoriePage()),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemCount: 4,
        itemBuilder: (_, i) => const ListTile(
          leading: CircleAvatar(),
          title: Text("Tour de manche"),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
          ),
        ),
      ),
    );
  }
}
